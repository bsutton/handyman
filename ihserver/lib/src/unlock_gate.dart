import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:shelf/shelf.dart';

import 'config.dart';
import 'credentials.dart';
import 'logger.dart';

UnlockGate? _gate;

Middleware unlockMiddleware() {
  final config = Config();
  return (_gate ??= UnlockGate(
    isUnlocked: () => config.isUnlocked,
    unlock: config.unlock,
    onFailure: qlogerr,
    origin: Uri(
      scheme: 'https',
      host: config.fqdn,
      port: config.httpsPort,
    ).origin,
  )).middleware;
}

/// A password-only bootstrap page; all application routes stay closed until
/// credentials have been validated. Never trust forwarded headers for TLS.
class UnlockGate {
  UnlockGate({
    required this.isUnlocked,
    required this.unlock,
    required this.origin,
    this.onFailure,
  });

  final bool Function() isUnlocked;
  final Future<void> Function(String password) unlock;
  final String origin;
  final void Function(String)? onFailure;
  final _nonce = base64Url.encode(
    List<int>.generate(32, (_) => Random.secure().nextInt(256)),
  );
  final _attempts = <DateTime>[];
  var _busy = false;

  static const _headers = {
    'content-type': 'text/html; charset=utf-8',
    'cache-control': 'no-store',
    // no-referrer makes browser form POSTs send Origin: null, which fails
    // the same-origin check below before the password is examined.
    'referrer-policy': 'same-origin',
    'x-content-type-options': 'nosniff',
    'x-frame-options': 'DENY',
    'content-security-policy':
        "default-src 'none'; form-action 'self'; frame-ancestors 'none'; "
        "base-uri 'none'",
  };

  Middleware get middleware =>
      (inner) => (request) async {
        if (request.url.path != 'unlock') {
          if (isUnlocked()) {
            return inner(request);
          }
          return Response(
            503,
            body: 'Service awaiting administrator unlock.',
            headers: {'cache-control': 'no-store', 'retry-after': '30'},
          );
        }
        if (request.requestedUri.scheme != 'https') {
          return Response(426, body: 'HTTPS is required.', headers: _headers);
        }
        if (isUnlocked()) {
          return Response.ok('Service is already unlocked.', headers: _headers);
        }
        if (request.method == 'GET') {
          return Response.ok(_page(), headers: _headers);
        }
        if (request.method != 'POST') {
          return Response(405, headers: {..._headers, 'allow': 'GET, POST'});
        }
        if (request.headers['origin'] != origin) {
          onFailure?.call('Unlock rejected: origin mismatch.');
          return Response(
            403,
            body: _page(
              'Unlock request rejected: origin mismatch. Open '
              '$origin/unlock in a fresh tab and retry.',
            ),
            headers: _headers,
          );
        }
        if (request.headers['content-type']?.split(';').first.trim() !=
            'application/x-www-form-urlencoded') {
          onFailure?.call('Unlock rejected: unsupported form content type.');
          return Response(
            403,
            body: _page(
              'Unsupported unlock submission. Reload the unlock '
              'page and use its form.',
            ),
            headers: _headers,
          );
        }
        final now = DateTime.now();
        _attempts.removeWhere((time) => now.difference(time).inMinutes >= 5);
        if (_busy || _attempts.length >= 5) {
          return Response(
            429,
            body: 'Please wait before trying again.',
            headers: {..._headers, 'retry-after': '300'},
          );
        }
        _busy = true;
        try {
          final body = <int>[];
          await for (final chunk in request.read().timeout(
            const Duration(seconds: 10),
          )) {
            body.addAll(chunk);
            if (body.length > 4096) {
              return Response(
                413,
                body: 'Request too large.',
                headers: _headers,
              );
            }
          }
          final form = Uri.splitQueryString(utf8.decode(body));
          if (form['csrf'] != _nonce) {
            onFailure?.call('Unlock rejected: expired or invalid form token.');
            return Response(
              403,
              body: _page(
                'This unlock form has expired or is invalid. '
                'Reload the page and retry.',
              ),
              headers: _headers,
            );
          }
          final password = form['password'];
          if (password == null || password.isEmpty) {
            return Response(
              400,
              body: _page('Enter the Lockbox password.'),
              headers: _headers,
            );
          }
          _attempts.add(now);
          await unlock(password);
          return Response.ok(
            '<!doctype html><html lang="en"><meta charset="utf-8"> '
            '<title>Service unlocked</title><h1>Service unlocked</h1> '
            '<p>The server can now use its credentials.</p><a href="/">Continue</a> '
            '</html>',
            headers: _headers,
          );
        } on CredentialException catch (error) {
          onFailure?.call(
            'Unlock failed: ${error.failure.name}. ${error.message}',
          );
          return Response(400, body: _page(error.message), headers: _headers);
        } catch (_) {
          onFailure?.call(
            'Unlock failed: unexpected failure; sensitive error '
            'details suppressed.',
          );
          // Includes native errors and parsing errors: never echo password/body.
          return Response(
            400,
            body: _page(
              'An unexpected error prevented unlocking. '
              'Check /var/log/ihserver.log for the unlock diagnostic.',
            ),
            headers: _headers,
          );
        } finally {
          _busy = false;
        }
      };

  String _page([String message = '']) {
    final error = message.isEmpty
        ? ''
        : '<section role="alert"><h2>Unlock failed</h2> '
              '<p>${const HtmlEscape().convert(message)}</p></section>';
    return '''
<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Unlock Handyman Server</title></head><body>
<main><h1>Unlock Handyman Server</h1>
<p>The service is waiting for its Lockbox password.</p>
$error
<form method="post" action="/unlock">
<input type="hidden" name="csrf" value="$_nonce">
<label>Lockbox password
<input type="password" name="password" required autofocus
 autocomplete="current-password" maxlength="1024"></label>
<button type="submit">Unlock server</button>
</form></main></body></html>''';
  }
}
