import 'dart:async';
import 'dart:io';

/// The URL is a bootstrap credential and must never appear in diagnostics.
class LockboxHeartbeat {
  LockboxHeartbeat({
    required this.url,
    required this.isUnlocked,
    required this.onFailure,
  });

  final String url;
  final bool Function() isUnlocked;
  final void Function() onFailure;
  Timer? _timer;
  var _sending = false;

  void start() {
    if (url.isEmpty) {
      return;
    }
    unawaited(send());
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      unawaited(send());
    });
  }

  static Uri endpoint(String url, {required bool unlocked}) {
    final base = Uri.parse(url);
    if (base.scheme != 'https' ||
        base.host != 'uptime.betterstack.com' ||
        !RegExp(r'^/api/v1/heartbeat/[^/]+/?$').hasMatch(base.path) ||
        base.hasQuery ||
        base.hasFragment ||
        base.userInfo.isNotEmpty ||
        base.port != 443) {
      throw const FormatException('Invalid Better Stack heartbeat URL.');
    }
    final path = base.path.replaceFirst(RegExp(r'/$'), '');
    return base.replace(path: unlocked ? path : '$path/fail');
  }

  Future<void> send() async {
    if (url.isEmpty || _sending) {
      return;
    }
    _sending = true;
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
    try {
      final uri = endpoint(url, unlocked: isUnlocked());
      final request = await client
          .getUrl(uri)
          .timeout(const Duration(seconds: 5));
      request.followRedirects = false;
      final response = await request.close().timeout(
        const Duration(seconds: 5),
      );
      await response.drain<void>().timeout(const Duration(seconds: 5));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        onFailure();
      }
    } catch (_) {
      onFailure();
    } finally {
      client.close(force: true);
      _sending = false;
    }
  }

  void close() => _timer?.cancel();
}
