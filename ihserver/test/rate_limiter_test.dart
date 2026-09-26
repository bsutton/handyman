import 'package:ihserver/src/servers/rate_limiter.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late DateTime now;
  late ClientRateLimiter limiter;
  late Handler handler;
  late int handled;

  Request request([String ip = '2001:db8::1']) => Request(
    'GET',
    Uri.parse('https://example.com/'),
    headers: {'cf-connecting-ip': ip},
  );

  setUp(() {
    now = DateTime.utc(2026);
    limiter = ClientRateLimiter(now: () => now);
    handled = 0;
    handler = limiter.rateLimiter()((request) {
      handled++;
      return Response.ok('ok');
    });
  });

  test('blocks for full 30 minutes, isolates clients and recovers', () async {
    for (var i = 0; i < 100; i++) {
      expect((await handler(request())).statusCode, 200);
    }
    now = now.add(const Duration(seconds: 59));
    final blocked = await handler(request());
    expect(blocked.statusCode, 429);
    expect(blocked.headers['retry-after'], '1800');
    expect(handled, 100);
    expect((await handler(request('2001:db8::2'))).statusCode, 200);
    now = now.add(const Duration(minutes: 29, seconds: 59));
    expect((await handler(request())).headers['retry-after'], '1');
    expect(handled, 101);
    now = now.add(const Duration(seconds: 1));
    expect((await handler(request())).statusCode, 200);
  });

  test('normal window resets without blocking', () async {
    for (var i = 0; i < 100; i++) {
      await handler(request());
    }
    now = now.add(const Duration(minutes: 1));
    expect((await handler(request())).statusCode, 200);
  });

  test(
    'a route-specific 429 also blocks other routes for that client',
    () async {
      final limited = limiter.rateLimiter()((_) => Response(429));
      expect((await limited(request())).headers['retry-after'], '1800');
      expect((await handler(request())).statusCode, 429);
      expect(handled, 0);
    },
  );
}
