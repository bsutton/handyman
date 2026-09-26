import 'dart:convert';
import 'dart:typed_data';

import 'package:ihserver/src/credentials.dart';
import 'package:revault_api/revault_api.dart';
import 'package:test/test.dart';

void main() {
  test('classifies native failures without exposing native text', () {
    final cases = <String, CredentialFailure>{
      'open failed or payload authentication failed':
          CredentialFailure.openAuthentication,
      'corrupt lockbox header': CredentialFailure.openCorrupt,
      'lock unavailable: secret-canary': CredentialFailure.openLocked,
      'io error: secret-canary': CredentialFailure.openIo,
      'lockbox transaction recovery is blocked: secret-canary':
          CredentialFailure.openRecovery,
      'secret-canary': CredentialFailure.openNative,
    };
    for (final entry in cases.entries) {
      final failure = classifyLockboxOpenFailure(RevaultException(entry.key));
      expect(failure, entry.value);
      expect(
        CredentialException(failure).toString(),
        isNot(contains('secret-canary')),
      );
    }
    expect(
      classifyLockboxOpenFailure(
        RevaultException(
          'secret-canary',
          details: ErrorDetails(
            category: 'unsupported_format_version',
            guidance: 'secret-canary',
          ),
        ),
      ),
      CredentialFailure.openFormat,
    );
    expect(
      classifyLockboxOpenFailure(UnsupportedError('secret-canary')),
      CredentialFailure.openRuntime,
    );
    expect(
      classifyLockboxOpenFailure(StateError('secret-canary')),
      CredentialFailure.open,
    );
  });

  setUpAll(Revault.load);

  late SecretString password;
  late Lockbox box;
  setUp(() {
    password = SecretString.fromString('synthetic-lockbox-password');
    box = Lockbox.createInMemory(password: password);
  });
  tearDown(() {
    box.close();
    password.close();
  });

  void secret(String name, String value) {
    final bytes = SecretBytes.take(Uint8List.fromList(utf8.encode(value)));
    try {
      box.setSecretVariable(name, bytes);
    } finally {
      bytes.close();
    }
  }

  ServerCredentials read() => ServerCredentials.fromLockbox(
    box,
    usernameVariable: '/gmail/user',
    passwordVariable: '/gmail/password',
    tokenVariable: '/hmb/token',
  );

  test('reads configured secret paths and preserves password bytes', () {
    secret('/gmail/user', 'synthetic@example.invalid');
    secret('/gmail/password', ' synthetic canary password\n');
    secret('/hmb/token', 'synthetic-token');
    final credentials = read();
    expect(credentials.username, 'synthetic@example.invalid');
    expect(credentials.password, ' synthetic canary password\n');
    expect(credentials.hmbApiToken, 'synthetic-token');
    expect(credentials.toString(), 'ServerCredentials(redacted)');
  });

  test('missing secret fails without exposing values', () {
    secret('/gmail/user', 'canary@example.invalid');
    expect(read, throwsA(isA<CredentialException>()));
    expect(const CredentialException().toString(), isNot(contains('canary')));
  });

  test('ordinary variables cannot substitute for secrets', () {
    box.setVariable('/gmail/user', 'ordinary-canary');
    expect(
      read,
      throwsA(
        isA<CredentialException>().having(
          (e) => e.failure,
          'failure',
          CredentialFailure.username,
        ),
      ),
    );
  });

  test('blank token fails closed', () {
    secret('/gmail/user', 'synthetic@example.invalid');
    secret('/gmail/password', 'password');
    secret('/hmb/token', '  ');
    expect(
      read,
      throwsA(
        isA<CredentialException>().having(
          (e) => e.failure,
          'failure',
          CredentialFailure.token,
        ),
      ),
    );
  });

  for (final path in ['/gmail/user', '/gmail/password', '/hmb/token']) {
    test('diagnostic identifies configured variable $path', () {
      for (final other in ['/gmail/user', '/gmail/password', '/hmb/token']) {
        if (other != path) {
          secret(other, 'secret-canary');
        }
      }
      box.setVariable(path, 'ordinary-canary');
      expect(
        read,
        throwsA(
          isA<CredentialException>()
              .having((e) => e.variablePath, 'variable path', path)
              .having(
                (e) => e.message,
                'expected variable',
                contains('Expected secret variable: "$path"'),
              )
              .having(
                (e) => e.toString(),
                'safe diagnostic',
                isNot(contains('canary')),
              ),
        ),
      );
    });
  }

  test('closed Lockbox errors are sanitized', () {
    box.close();
    expect(read, throwsA(isA<CredentialException>()));
  });
}
