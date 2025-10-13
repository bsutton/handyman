import 'dart:async';
import 'dart:io';

import 'package:cron/cron.dart';
import 'package:dcli/dcli.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_letsencrypt/shelf_letsencrypt.dart';

import '../certificate.dart';
import '../config.dart';
import '../logger.dart';
import '../middleware/log_client_ip.dart';
import '../router.dart';
import 'rate_limiter.dart';

enum CertificateMode { staging, production }

late HttpServer server;
late HttpServer secureServer;

Future<void> startHttpsServer(Domain domain) async {
  final letsEncrypt = build(
    mode:
        Config().production
            ? CertificateMode.production
            : CertificateMode.staging,
  );
  await _startHttpsServer(letsEncrypt, domain);

  await _startRenewalService(letsEncrypt, domain);
}

Future<void> _startHttpsServer(LetsEncrypt letsEncrypt, Domain domain) async {
  final router = buildRouter();

  final redirectToHttps = createMiddleware(requestHandler: _redirectToHttps);

  final handler = const Pipeline()
      .addMiddleware(redirectToHttps)
      .addMiddleware(logClientRequestMiddleware())
      .addMiddleware(rateLimiter.rateLimiter())
      .addHandler(router.call);

  final servers = await letsEncrypt.startServer(handler, [domain]);

  server = servers[0]; // HTTP Server.
  secureServer = servers[1]; // HTTPS Server.

  // Enable gzip:
  server.autoCompress = true;
  secureServer.autoCompress = true;

  qlog('Serving at http://${server.address.host}:${server.port}');
  qlog('Serving at https://${secureServer.address.host}:${secureServer.port}');
}

/// Redirect all http traffic to https.
/// This shouldn't interfere with lets encrypt as ti hooks
/// into the  pipeline before this middleware is called.
FutureOr<Response?> _redirectToHttps(Request request) {
  if (request.requestedUri.scheme == 'http') {
    final headers = <String, String>{
      'location':
          '''${request.requestedUri.replace(scheme: "https", port: Config().httpsPort)}''',
    };
    return Response(302, headers: headers);
  }
  return null;
}

Future<void> _startRenewalService(
  LetsEncrypt letsEncrypt,
  Domain domain,
) async {
  final httpPort = Config().httpPort;
  Cron().schedule(
    Schedule(hours: '*/1'), // every hour
    () => refreshIfRequired(httpPort, letsEncrypt, domain),
  );
}

Future<void> refreshIfRequired(
  int httpPort,
  LetsEncrypt letsEncrypt,
  Domain domain,
) async {
  qlog(blue('Checking if cert needs to be renewed'));
  final result = await letsEncrypt.checkCertificate(
    domain,
    requestCertificate: true,
  );

  if (result.isOkRefreshed) {
    qlog(blue('certificate was renewed - restarting service'));
    // restart the servers.
    await Future.wait<void>([server.close(), secureServer.close()]);
    await _startHttpsServer(letsEncrypt, domain);
    qlog(blue('services restarted'));
  } else {
    qlog(blue('Renewal not required'));
  }
}
