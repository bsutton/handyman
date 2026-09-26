import 'package:shelf/shelf.dart';

import '../middleware/log_client_ip.dart';

final rateLimiter = ClientRateLimiter();

/// Allow 100 requests per minute per client, then block for 30 minutes.
/// State is shared by HTTP and HTTPS and lasts until the process restarts.
class ClientRateLimiter {
  ClientRateLimiter({DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const maxRequests = 100;
  static const window = Duration(minutes: 1);
  static const blockDuration = Duration(minutes: 30);
  final DateTime Function() _now;
  final _clients = <String, _ClientLimit>{};
  DateTime? _nextCleanup;

  Middleware rateLimiter() =>
      (inner) => (request) async {
        final now = _now();
        if (_nextCleanup == null || !now.isBefore(_nextCleanup!)) {
          _clients.removeWhere((_, state) => !now.isBefore(state.expires));
          _nextCleanup = now.add(window);
        }
        final key = getClientIp(request);
        var state = _clients[key];
        if (state == null || !now.isBefore(state.expires)) {
          state = _ClientLimit(now.add(window));
          _clients[key] = state;
        }
        if (state.blocked) {
          return _blocked(state, now);
        }
        if (state.requests >= maxRequests) {
          state
            ..blocked = true
            ..expires = now.add(blockDuration);
          return _blocked(state, now);
        }
        state.requests++;
        final remaining = maxRequests - state.requests;
        final reset = state.expires.millisecondsSinceEpoch ~/ 1000;
        final response = await inner(request);
        // Apply the same cooldown when a route has its own tighter limit.
        if (response.statusCode == 429) {
          state
            ..blocked = true
            ..expires = _now().add(blockDuration);
          _clients[key] = state;
          return _blocked(state, _now());
        }
        return response.change(
          headers: {
            'X-RateLimit-Limit': '$maxRequests',
            'X-RateLimit-Remaining': '$remaining',
            'X-RateLimit-Reset': '$reset',
          },
        );
      };

  Response _blocked(_ClientLimit state, DateTime now) => Response(
    429,
    body: 'Too many requests. Please try again later.',
    headers: {
      'retry-after':
          '${(state.expires.difference(now).inMilliseconds / 1000).ceil()}',
      'cache-control': 'no-store',
      'X-RateLimit-Limit': '$maxRequests',
      'X-RateLimit-Remaining': '0',
      'X-RateLimit-Reset':
          '${(state.expires.millisecondsSinceEpoch / 1000).ceil()}',
    },
  );
}

class _ClientLimit {
  _ClientLimit(this.expires);

  DateTime expires;
  var requests = 0;
  var blocked = false;
}
