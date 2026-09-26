import 'dart:async';
import 'dart:io';

// import 'package:basic_utils/basic_utils.dart';
import 'package:basic_utils/basic_utils.dart' hide Domain;
import 'package:cron/cron.dart';
import 'package:dcli/dcli.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_letsencrypt/shelf_letsencrypt.dart'; // hide Domain;

import '../certificate.dart';
import '../config.dart';
import '../logger.dart';
import '../middleware/log_client_ip.dart';
import '../router.dart';
import '../unlock_gate.dart';
import 'rate_limiter.dart';

enum CertificateMode { staging, production }

late HttpServer server;
late HttpServer secureServer;

Future<void> startHttpsServer(List<Domain> domains) async {
  final letsEncrypt = build(
    mode: Config().production
        ? CertificateMode.production
        : CertificateMode.staging,
  );
  await _startHttpsServer(letsEncrypt, domains);

  await _startRenewalService(letsEncrypt, domains);
}

Future<void> _startHttpsServer(
  LetsEncrypt letsEncrypt,
  List<Domain> domains,
) async {
  final router = buildRouter();

  final redirectToHttps = createMiddleware(requestHandler: _redirectToHttps);

  final handler = const Pipeline()
      .addMiddleware(redirectToHttps)
      .addMiddleware(logClientRequestMiddleware())
      .addMiddleware(rateLimiter.rateLimiter())
      .addMiddleware(unlockMiddleware())
      .addHandler(router.call);

  final servers = await letsEncrypt.startServer(handler, domains);

  server = servers.http;
  secureServer = servers.https;

  // Enable gzip:
  server.autoCompress = true;
  secureServer.autoCompress = true;

  final httpUri = Uri(
    scheme: 'http',
    host: server.address.address,
    port: server.port,
  );
  qlog('Serving at $httpUri');
  final httpsUri = Uri(
    scheme: 'https',
    host: secureServer.address.address,
    port: secureServer.port,
  );
  qlog('Serving at $httpsUri');
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
  List<Domain> domains,
) async {
  Cron().schedule(
    Schedule(hours: '*/1'), // every hour
    () => refreshIfRequired(letsEncrypt, domains),
  );
}

Future<void> refreshIfRequired(
  LetsEncrypt letsEncrypt,
  List<Domain> domains,
) async {
  var renewed = false;
  for (final domain in domains) {
    if (await _refreshDomain(letsEncrypt, domain)) {
      renewed = true;
    }
  }
  if (renewed) {
    qlog(blue('Certificates renewed - restarting HTTPS service'));
    await Future.wait<void>([server.close(), secureServer.close()]);
    await _startHttpsServer(letsEncrypt, domains);
    qlog(blue('HTTPS service restarted'));
  }
}

Future<bool> _refreshDomain(LetsEncrypt letsEncrypt, Domain domain) async {
  /// Checks the local certificate expiry and forces renewal when it's missing,
  /// expired, or within the minimum validity window, then restarts servers if
  /// a new certificate was issued.
  qlog(blue('Checking certificate renewal for ${domain.name}'));
  final timeLeft = _localCertificateTimeLeft(letsEncrypt, domain);

  // renewal trigger in line with the eventually shorter certificate
  // lifespan of 45days.
  const minValidity = Duration(days: 15);
  final forceRenewal =
      timeLeft == null || timeLeft.isNegative || timeLeft < minValidity;
  if (forceRenewal) {
    final hoursLeft = timeLeft?.inHours;
    final reason = hoursLeft == null
        ? 'local certificate unavailable'
        : 'local certificate expires in ${hoursLeft}h';
    qlog(blue('Forcing renewal check for ${domain.name}: $reason'));
  }
  final result = await letsEncrypt.checkCertificate(
    domain,
    requestCertificate: true,
    forceRequestCertificate: forceRenewal,
  );

  if (result.isOkRefreshed) {
    qlog(blue('Certificate renewed for ${domain.name}'));
    return true;
  } else if (result.isOK) {
    qlog(blue('Renewal not required for ${domain.name}'));
  } else {
    qlogerr('Certificate renewal failed for ${domain.name}: $result');
  }
  return false;
}

Duration? _localCertificateTimeLeft(LetsEncrypt letsEncrypt, Domain domain) {
  final config = Config();
  final fullChainPath =
      '${config.letsEncryptLive}/${domain.name}/${letsEncrypt.certificatesHandler.fullChainPEMFileName}';
  final fullChainFile = File(fullChainPath);
  if (!fullChainFile.existsSync()) {
    return null;
  }

  final pem = fullChainFile.readAsStringSync();
  final match = RegExp(
    r'-----BEGIN CERTIFICATE-----[\s\S]+?-----END CERTIFICATE-----',
  ).firstMatch(pem);
  if (match == null) {
    return null;
  }

  final certificate = X509Utils.x509CertificateFromPem(match.group(0)!);
  final notAfter = certificate.tbsCertificate?.validity.notAfter;
  if (notAfter == null) {
    return null;
  }

  return notAfter.difference(DateTime.now());
}
