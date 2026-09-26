import 'dart:async';

import 'package:ihserver/src/credentials.dart';
import 'package:ihserver/src/unlock_gate.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late bool unlocked;
  late UnlockGate gate;
  late Handler handler;
  setUp(() {
    unlocked = false;
    gate = UnlockGate(
      isUnlocked: () => unlocked,
      unlock: (password) async {
        if (password != 'synthetic-password') {
          throw StateError(password);
        }
        unlocked = true;
      },
      origin: 'https://example.invalid',
    );
    handler = gate.middleware((_) => Response.ok('application'));
  });

  Future<String> nonce() async {
    final page = await handler(
      Request('GET', Uri.parse('https://example.invalid/unlock')),
    );
    expect(page.headers['cache-control'], 'no-store');
    expect(page.headers['referrer-policy'], 'same-origin');
    final html = await page.readAsString();
    return RegExp('name="csrf" value="([^"]+)"').firstMatch(html)!.group(1)!;
  }

  Request post(String token, String password, {String? origin}) => Request(
    'POST',
    Uri.parse('https://example.invalid/unlock'),
    headers: {
      'origin': origin ?? 'https://example.invalid',
      'content-type': 'application/x-www-form-urlencoded',
    },
    body: Uri(queryParameters: {'csrf': token, 'password': password}).query,
  );

  test(
    'locked application returns 503, unlock page remains available',
    () async {
      final response = await handler(
        Request('GET', Uri.parse('https://example.invalid/')),
      );
      expect(response.statusCode, 503);
      expect(await nonce(), isNotEmpty);
    },
  );

  test('valid unlock enables application routes', () async {
    final response = await handler(post(await nonce(), 'synthetic-password'));
    expect(response.statusCode, 200);
    expect(unlocked, isTrue);
    final app = await handler(
      Request('GET', Uri.parse('https://example.invalid/')),
    );
    expect(await app.readAsString(), 'application');
  });

  test('password and echoed exception never appear in response', () async {
    final response = await handler(post(await nonce(), 'failure-canary'));
    expect(response.statusCode, 400);
    expect(await response.readAsString(), isNot(contains('failure-canary')));
    expect(unlocked, isFalse);
  });

  test('rejects HTTP, foreign origins and invalid CSRF tokens', () async {
    final http = await handler(
      Request('GET', Uri.parse('http://example.invalid/unlock')),
    );
    expect(http.statusCode, 426);
    final foreign = await handler(
      post(await nonce(), 'synthetic-password', origin: 'https://evil.invalid'),
    );
    expect(foreign.statusCode, 403);
    expect(
      (await handler(post('wrong', 'synthetic-password'))).statusCode,
      403,
    );
    expect(unlocked, isFalse);
  });

  test(
    'rejects null and missing origins even with a valid CSRF token',
    () async {
      final token = await nonce();
      expect(
        (await handler(
          post(token, 'synthetic-password', origin: 'null'),
        )).statusCode,
        403,
      );
      final missing = Request(
        'POST',
        Uri.parse('https://example.invalid/unlock'),
        headers: {'content-type': 'application/x-www-form-urlencoded'},
        body: Uri(
          queryParameters: {'csrf': token, 'password': 'synthetic-password'},
        ).query,
      );
      expect((await handler(missing)).statusCode, 403);
      expect(unlocked, isFalse);
    },
  );

  test(
    'shows and logs safe credential diagnosis without secret values',
    () async {
      final messages = <String>[];
      gate = UnlockGate(
        isUnlocked: () => false,
        origin: 'https://example.invalid',
        onFailure: messages.add,
        unlock: (_) async => throw const CredentialException.variable(
          CredentialFailure.token,
          '/custom/hmb_token',
        ),
      );
      handler = gate.middleware((_) => Response.ok('application'));
      final response = await handler(post(await nonce(), 'secret-canary'));
      final body = await response.readAsString();
      expect(response.statusCode, 400);
      expect(body, contains('HMB API token'));
      expect(body, contains('&#47;custom&#47;hmb_token'));
      expect(messages.single, contains('/custom/hmb_token'));
      expect(body, contains('<section role="alert"><h2>Unlock failed</h2>'));
      expect(messages.single, contains('Unlock failed: token'));
      expect(body, isNot(contains('secret-canary')));
      expect(messages.join(), isNot(contains('secret-canary')));
    },
  );

  test('unexpected errors are not echoed in diagnostics', () async {
    final messages = <String>[];
    gate = UnlockGate(
      isUnlocked: () => false,
      origin: 'https://example.invalid',
      onFailure: messages.add,
      unlock: (password) async => throw StateError(password),
    );
    handler = gate.middleware((_) => Response.ok('application'));
    final response = await handler(post(await nonce(), 'secret-canary'));
    expect(await response.readAsString(), isNot(contains('secret-canary')));
    expect(messages.single, isNot(contains('secret-canary')));
  });

  test('expired form explains that the page must be reloaded', () async {
    final response = await handler(post('stale-token', 'secret-canary'));
    expect(response.statusCode, 403);
    expect(await response.readAsString(), contains('Reload the page'));
  });

  test('rate limits repeated guesses globally', () async {
    final token = await nonce();
    for (var i = 0; i < 5; i++) {
      expect((await handler(post(token, 'wrong'))).statusCode, 400);
    }
    expect((await handler(post(token, 'synthetic-password'))).statusCode, 429);
    expect(unlocked, isFalse);
  });

  test('rejects oversized request bodies', () async {
    final response = await handler(post(await nonce(), 'x' * 5000));
    expect(response.statusCode, 413);
    expect(unlocked, isFalse);
  });

  test('allows only one password operation at a time', () async {
    final entered = Completer<void>();
    final finish = Completer<void>();
    gate = UnlockGate(
      isUnlocked: () => false,
      origin: 'https://example.invalid',
      unlock: (_) async {
        entered.complete();
        await finish.future;
      },
    );
    handler = gate.middleware((_) => Response.ok('application'));
    final token = await nonce();
    final first = handler(post(token, 'synthetic-password'));
    await entered.future;
    expect((await handler(post(token, 'synthetic-password'))).statusCode, 429);
    finish.complete();
    await first;
  });
}
