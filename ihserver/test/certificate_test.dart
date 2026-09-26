import 'dart:io';

import 'package:ihserver/src/certificate_domains.dart';
import 'package:ihserver/src/certificate_store.dart';
import 'package:ihserver/src/handyman_letsencrypt.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_letsencrypt/shelf_letsencrypt.dart';
import 'package:test/test.dart';

void main() {
  test('accepts four-part domains and rejects malformed hostnames', () {
    expect(
      const CertificateDomain(
        name: 'hmb.ivanhoehandyman.com.au',
        email: 'test@example.com',
      ).isValidName,
      isTrue,
    );
    for (final name in [
      'bad..example.com',
      '-bad.example.com',
      'bad-.example.com',
      'https://example.com',
      '*.example.com',
    ]) {
      expect(
        CertificateDomain(name: name, email: 'test@example.com').isValidName,
        isFalse,
        reason: name,
      );
    }
  });

  test('includes HMB for Handyman but keeps development domains isolated', () {
    for (final primary in [
      'ivanhoehandyman.com.au',
      'www.ivanhoehandyman.com.au',
    ]) {
      expect(certificateDomainNames(primary), [
        primary,
        'hmb.ivanhoehandyman.com.au',
      ]);
    }
    expect(certificateDomainNames('squarephone.biz'), ['squarephone.biz']);
    expect(certificateDomainNames('ivanhoehandyman.com.au', additional: []), [
      'ivanhoehandyman.com.au',
    ]);
    expect(
      certificateDomainNames(
        'example.com',
        additional: ['example.com', 'a.example.com'],
      ),
      ['example.com', 'a.example.com'],
    );
  });

  test('reports missing contexts without opaque object labels', () async {
    final directory = Directory.systemTemp.createTempSync('ihserver-certs-');
    addTearDown(() => directory.deleteSync(recursive: true));
    final messages = <String>[];
    final store = CertificateStore(directory, log: messages.add);
    final contexts = await store.buildSecurityContexts([
      const Domain(name: 'example.com', email: 'test@example.com'),
    ], loadAllHandledDomains: false);
    expect(contexts, isNull);
    expect(
      messages.single,
      contains('unavailable; requested domains: example.com'),
    );
    expect(messages.single, isNot(contains('Instance of')));
  });

  test('serves the matching certificate for both HTTPS hostnames', () async {
    final directory = Directory.systemTemp.createTempSync('ihserver-tls-');
    addTearDown(() => directory.deleteSync(recursive: true));
    final messages = <String>[];
    final store = CertificateStore(directory, log: messages.add);
    final domains = certificateDomainNames('ivanhoehandyman.com.au')
        .map((name) => CertificateDomain(name: name, email: 'test@example.com'))
        .toList();
    for (final domain in domains) {
      Directory('${directory.path}/${domain.name}').createSync();
      final generated = await Process.run('openssl', [
        'req',
        '-x509',
        '-newkey',
        'rsa:2048',
        '-nodes',
        '-days',
        '2',
        '-subj',
        '/CN=${domain.name}',
        '-addext',
        'subjectAltName=DNS:${domain.name}',
        '-keyout',
        store.fileDomainPrivateKeyPEM(domain.name).path,
        '-out',
        store.fileDomainFullChainPEM(domain.name).path,
      ]);
      expect(generated.exitCode, 0, reason: '${generated.stderr}');
    }
    final letsEncrypt = HandymanLetsEncrypt(
      store,
      bindingAddress: '127.0.0.1',
      port: 0,
      securePort: 0,
      log: (level, message, error, stack) {},
    );
    final servers = await letsEncrypt.startServer(
      (request) => Response.ok('ok'),
      domains,
      checkCertificate: false,
      requestCertificate: false,
    );
    expect(domains, hasLength(2));
    addTearDown(() async {
      await servers.http.close(force: true);
      await servers.https.close(force: true);
    });
    for (final domain in domains) {
      final client = HttpClient()
        ..connectionFactory = ((uri, proxyHost, proxyPort) async {
          final socket = await Socket.connect('127.0.0.1', servers.https.port);
          return ConnectionTask.fromSocket(
            SecureSocket.secure(
              socket,
              host: domain.name,
              onBadCertificate: (certificate) => true,
            ),
            socket.destroy,
          );
        })
        ..badCertificateCallback = ((certificate, host, port) => true);
      try {
        final request = await client.getUrl(
          Uri.https('${domain.name}:${servers.https.port}', '/'),
        );
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(response.certificate!.subject, contains('CN=${domain.name}'));
        await response.drain<void>();
      } finally {
        client.close(force: true);
      }
    }
    expect(messages.single, contains('ivanhoehandyman.com.au: certificate='));
    expect(
      messages.single,
      contains('hmb.ivanhoehandyman.com.au: certificate='),
    );
    expect(messages.single, contains('names=[hmb.ivanhoehandyman.com.au]'));
    expect(messages.single, contains('expires='));
    expect(messages.single, isNot(contains('metadata unavailable')));
    expect(messages.single, isNot(contains('PRIVATE KEY')));
    expect(messages.single, isNot(contains('Instance of')));
  });
}
