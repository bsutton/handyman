// [fqdn] is the fqdn for the HTTPS certificate
import 'dart:io';

import 'package:shelf_letsencrypt/shelf_letsencrypt.dart';

import 'certificate_store.dart';
import 'config.dart';
import 'handyman_letsencrypt.dart';
import 'servers/https.dart';

LetsEncrypt build({CertificateMode mode = CertificateMode.staging}) {
  final config = Config();
  final certificatesDirectory = config.letsEncryptLive;

  // The Certificate handler, storing at `certificatesDirectory`.
  final certificatesHandler = CertificateStore(
    Directory(certificatesDirectory),
  );

  final letsEncrypt = HandymanLetsEncrypt(
    certificatesHandler,
    port: config.httpPort,
    securePort: config.httpsPort,
    bindingAddress: config.bindingAddress,
    production: mode == CertificateMode.production,
    log: logCertificateEvent,
  )..minCertificateValidityTime = const Duration(days: 10);

  return letsEncrypt;
}
