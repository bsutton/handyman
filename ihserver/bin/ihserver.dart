#! /usr/bin/env dcli
// ignore_for_file: avoid_types_on_closure_parameters

import 'dart:async';
import 'dart:io';

import 'package:cron/cron.dart';
import 'package:dcli/dcli.dart';
import 'package:dnsolve/dnsolve.dart';
import 'package:ihserver/src/config.dart';
import 'package:ihserver/src/handle_booking.dart';
import 'package:ihserver/src/handle_static.dart';
import 'package:ihserver/src/logger.dart';
import 'package:ihserver/src/mailer.dart';
import 'package:path/path.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_letsencrypt/shelf_letsencrypt.dart';
import 'package:shelf_rate_limiter/shelf_rate_limiter.dart';
import 'package:shelf_router/shelf_router.dart';

enum CertificateMode { staging, production }

late HttpServer server;
late HttpServer secureServer;

/// Simple web server that can serve stastic content and email
/// a booking.
void main() async {
  final config = Config();
  final pathToStaticContent = config.pathToStaticContent;
  await _checkConfiguration(pathToStaticContent);

  await _checkFQDNResolved(config.fqdn);

  final domain = Domain(name: config.fqdn, email: config.domainEmail);

  final letsEncrypt = build(
      mode: Config().production
          ? CertificateMode.production
          : CertificateMode.staging);

  if (Config().useHttps) {
    await _startHttpsServer(letsEncrypt, domain);
    await _startRenewalService(letsEncrypt, domain);
  } else {
    await _startWebServer();
  }

  await _sendTestEmail();
}

Future<void> _checkFQDNResolved(String fqdn) async {
  final dnsolve = DNSolve();
  final response = await dnsolve.lookup(fqdn);
  if (response.answer?.records != null) {
    for (final record in response.answer!.records!) {
      qlog(record.toBind);
    }
  }
}

Future<void> _startRenewalService(
    LetsEncrypt letsEncrypt, Domain domain) async {
  final httpPort = Config().httpPort;
  Cron().schedule(
      Schedule(hours: '*/1'), // every hour
      () => refreshIfRequired(httpPort, letsEncrypt, domain));
}

Future<void> refreshIfRequired(
    int httpPort, LetsEncrypt letsEncrypt, Domain domain) async {
  qlog(blue('Checking if cert needs to be renewed'));
  final result =
      await letsEncrypt.checkCertificate(domain, requestCertificate: true);

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

Future<void> _startWebServer() async {
  final router = _buildRouter();

  final handler = const Pipeline()
      .addMiddleware(logRequests(logger: _log))
      .addMiddleware(rateLimiter.rateLimiter())
      .addHandler(router.call);

  final server = await serve(
    handler,
    Config().bindingAddress,
    Config().httpPort,
  );
  qlog('Serving at http://${server.address.host}:${server.port}');
}

Future<void> _startHttpsServer(LetsEncrypt letsEncrypt, Domain domain) async {
  final router = _buildRouter();

  final redirectToHttps = createMiddleware(requestHandler: _redirectToHttps);

  final handler = const Pipeline()
      .addMiddleware(redirectToHttps)
      .addMiddleware(logRequests(logger: _log))
      .addMiddleware(rateLimiter.rateLimiter())
      .addHandler(router.call);

  final servers = await letsEncrypt.startServer(
    handler,
    [domain],
  );

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
FutureOr<Response?> _redirectToHttps(Request request) async {
  if (request.requestedUri.scheme == 'http') {
    final headers = <String, String>{
      'location':
          '''${request.requestedUri.replace(scheme: "https", port: Config().httpsPort)}'''
    };
    return Response(302, headers: headers);
  }
  return null;
}

void _log(String message, bool isError) {
  qlog(orange(message));
}

Router _buildRouter() {
  final router = Router()
    ..get('/', handleDefault)
    ..get('/<.*>', handleStatic)
    ..get('/css/<.*>', handleStatic)
    ..get('/js/<.*>', handleStatic)
    ..get('/images/<.*>', handleStatic)
    ..get('/images/samples/<.*>', handleStatic)

    /// validates deep links used by the hmb app.
    ..get('/.well-known/assetlinks.json', handleStatic)
    ..post('/booking', (Request request) async => handleBooking(request));
  return router;
}

// [fqdn] is the fqdn for the HTTPS certificate
LetsEncrypt build({CertificateMode mode = CertificateMode.staging}) {
  final config = Config();
  final certificatesDirectory = config.letsEncryptLive;

  // The Certificate handler, storing at `certificatesDirectory`.
  final certificatesHandler =
      CertificatesHandlerIO(Directory(certificatesDirectory));

  final letsEncrypt = LetsEncrypt(certificatesHandler,
      port: config.httpPort,
      securePort: config.httpsPort,
      bindingAddress: config.bindingAddress,
      selfTest: false,
      production: mode == CertificateMode.production)
    ..minCertificateValidityTime = const Duration(days: 10);

  return letsEncrypt;
}

Future<void> _checkConfiguration(String pathToStaticContent) async {
  qlog(green('Starting Handyman Server'));
  qlog(blue('Loading config.yaml from ${truepath(Config().loadedFrom)}'));
  qlog(blue('Path to static content: $pathToStaticContent'));
  final pathToIndexHtml = join(pathToStaticContent, 'index.html');

  if (!exists(pathToIndexHtml)) {
    qlogerr(red('Missing index.html in $pathToIndexHtml'));
    exit(32);
  }
  qlog(blue('Starting web server'));
}

Future<void> _sendTestEmail() async {
  qlog('Sending test email to bsutton@onepub.dev');
  final result = await sendEmail(
      from: 'startup@onepub.dev',
      to: 'bsutton@onepub.dev',
      subject: 'Handy Server Starting',
      body: 'The Handy Server has been restarted');

  if (!result) {
    qlogerr(red(
        '''Failed to send startup email: check the configuration at ${Config().loadedFrom}'''));
    exit(33);
  }
}

/// define a memory backed ratelimiter to 10 requests per minute.
final memoryStorage = MemStorage();
final rateLimiter = ShelfRateLimiter(
    storage: memoryStorage,
    duration: const Duration(seconds: 60),
    maxRequests: 100);
