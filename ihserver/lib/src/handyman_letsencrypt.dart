import 'dart:io';

import 'package:shelf_letsencrypt/shelf_letsencrypt.dart';

import 'certificate_request_backoff.dart';

/// Preserve the disabled ACME self-test used behind the production router.
/// The CA still validates the challenge over public HTTP independently.
class HandymanLetsEncrypt extends LetsEncrypt {
  HandymanLetsEncrypt(
    CertificatesHandlerIO super.certificatesHandler, {
    super.port,
    super.securePort,
    super.bindingAddress,
    super.production,
    super.log,
  }) : _backoff = CertificateRequestBackoff(
         Directory(
           '${certificatesHandler.directory.path}/.acme-retry/${production ? 'production' : 'staging'}',
         ),
       );

  final CertificateRequestBackoff _backoff;

  @override
  Future<bool> requestCertificate(Domain domain) =>
      _backoff.request(domain.name, () => super.requestCertificate(domain));

  @override
  Future<String?> getURL(
    Uri url, {
    Duration? minCertificateValidityTime,
    bool checkCertificate = true,
    bool log = true,
  }) {
    if (url.scheme == 'http' && LetsEncrypt.isACMEPath(url.path)) {
      final token = getChallengeToken(url.host);
      if (token != null) {
        return Future.value(token);
      }
    }
    return super.getURL(
      url,
      minCertificateValidityTime: minCertificateValidityTime,
      checkCertificate: checkCertificate,
      log: log,
    );
  }
}
