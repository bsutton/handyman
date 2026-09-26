import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ihserver/src/config.dart';
import 'package:ihserver/src/credentials.dart';
import 'package:revault_api/revault_api.dart';
import 'package:test/test.dart';

void main() {
  test(
    'password unlock loads format-3 credentials, ignoring plaintext YAML',
    () async {
      await Revault.load();
      final original = Directory.current;
      final temp = Directory.systemTemp.createTempSync('ihserver-credentials-');
      final password = SecretString.fromString('synthetic-unlock-password');
      try {
        Directory.current = temp;
        Directory('config').createSync();
        File('config/config.yaml').writeAsStringSync('''
path_to_static_content: www
fqdn: example.invalid
domain_email: ""
use_https: true
gmail_app_username: ignored-plaintext-user
gmail_app_password: ignored-plaintext-password
hmb_api_token: ignored-plaintext-token
lockbox_heartbeat_url: secret-heartbeat-canary
''');
        final box = Lockbox.create('config/ihserver.lbox', password: password);
        try {
          for (final entry in {
            '/gmail_app_username': 'test@example.invalid',
            '/gmail_app_password': 'synthetic-mail-password',
            '/hmb_api_token': 'synthetic-api-token',
          }.entries) {
            final secret = SecretBytes.take(
              Uint8List.fromList(utf8.encode(entry.value)),
            );
            try {
              box.setSecretVariable(entry.key, secret);
            } finally {
              secret.close();
            }
          }
          box.commit();
        } finally {
          box.close();
        }
        // Guard the native engine's on-disk format compatibility, not just
        // the Dart API: this service must read the existing v3 Lockboxes.
        final archive = File('config/ihserver.lbox').readAsBytesSync();
        expect(utf8.decode(archive.sublist(0, 8)), 'LBX3HDR\u0000');
        expect(
          ByteData.sublistView(archive, 8, 10).getUint16(0, Endian.little),
          3,
        );
        final config = Config();
        final report = config.startupReport.join('\n');
        expect(report, contains('Loading config.yaml from:'));
        expect(report, contains('required setting "domain_email" is missing'));
        expect(report, contains('http_port:'));
        expect(report, contains('80 (default)'));
        expect(report, contains('Static index:'));
        expect(report, contains('MISSING'));
        expect(report, contains('Lockbox:'));
        expect(report, contains('present but ignored'));
        expect(report, isNot(contains('ignored-plaintext')));
        expect(report, isNot(contains('secret-heartbeat-canary')));
        expect(config.isUnlocked, isFalse);
        await expectLater(
          config.unlock('wrong-canary-password'),
          throwsA(
            isA<CredentialException>()
                .having(
                  (e) => e.failure,
                  'failure',
                  CredentialFailure.openAuthentication,
                )
                .having(
                  (e) => e.message,
                  'safe diagnostic',
                  isNot(contains('wrong-canary-password')),
                ),
          ),
        );
        expect(config.isUnlocked, isFalse);
        await config.unlock('synthetic-unlock-password');
        await config.whenUnlocked;
        expect(config.isUnlocked, isTrue);
        expect(config.username, 'test@example.invalid');
        expect(config.password, 'synthetic-mail-password');
        expect(config.hmbApiToken, 'synthetic-api-token');
      } finally {
        password.close();
        Directory.current = original;
        temp.deleteSync(recursive: true);
      }
    },
  );
}
