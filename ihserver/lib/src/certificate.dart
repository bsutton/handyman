// [fqdn] is the fqdn for the HTTPS certificate
import 'dart:io';

import 'package:shelf_letsencrypt/shelf_letsencrypt.dart';

import 'config.dart';
import 'servers/https.dart';

LetsEncrypt build({CertificateMode mode = CertificateMode.staging}) {
  final config = Config();
  final certificatesDirectory = config.letsEncryptLive;

  // The Certificate handler, storing at `certificatesDirectory`.
  final certificatesHandler = CertificatesHandlerIO(
    Directory(certificatesDirectory),
  );

  final letsEncrypt = LetsEncrypt(
    certificatesHandler,
    port: config.httpPort,
    securePort: config.httpsPort,
    bindingAddress: config.bindingAddress,
    selfTest: false,
    production: mode == CertificateMode.production,
  )..minCertificateValidityTime = const Duration(days: 10);

  return letsEncrypt;
}
