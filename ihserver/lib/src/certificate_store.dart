import 'dart:io';

import 'package:basic_utils/basic_utils.dart' hide Domain;
import 'package:shelf_letsencrypt/shelf_letsencrypt.dart';

import 'logger.dart';

/// Reports public certificate details for the contexts actually being loaded.
class CertificateStore extends CertificatesHandlerIO {
  CertificateStore(super.directory, {void Function(String)? log})
    : _log = log ?? qlog;

  final void Function(String) _log;

  @override
  Future<Map<String, SecurityContext>?> buildSecurityContexts(
    List<Domain> domains, {
    bool allowUnresolvedDomain = false,
    bool loadAllHandledDomains = true,
  }) async {
    final contexts = await super.buildSecurityContexts(
      domains,
      allowUnresolvedDomain: allowUnresolvedDomain,
      loadAllHandledDomains: loadAllHandledDomains,
    );
    final details = contexts == null || contexts.isEmpty
        ? 'unavailable; requested domains: ${Domain.toNames(domains)}'
        : contexts.keys.map(_describe).join('; ');
    _log(
      '${DateTime.now()} [INFO] LetsEncrypt > '
      'TLS contexts[loadAllHandledDomains: $loadAllHandledDomains]: $details',
    );
    return contexts;
  }

  String _describe(String domain) {
    final file = fileDomainFullChainPEM(domain);
    try {
      final certificate = X509Utils.x509CertificateFromPem(
        file.readAsStringSync(),
      );
      final data = certificate.tbsCertificate;
      return '$domain: certificate=${file.path}, '
          'names=${data?.extensions?.subjectAlternativNames}, '
          'issuer=${data?.issuer}, '
          'expires=${data?.validity.notAfter.toUtc().toIso8601String()}';
    } on Object {
      // Diagnostics must not prevent an otherwise valid TLS context loading.
      return '$domain: certificate=${file.path}, metadata unavailable';
    }
  }
}

/// Route ACME diagnostics through the same rotating log as the application.
void logCertificateEvent(
  String level,
  Object? message,
  Object? error,
  StackTrace? stackTrace,
) {
  // CertificateStore logs details when contexts are built, including after
  // issuance. The library's SecurityContext.toString adds no information.
  if (message?.toString().startsWith('securityContext[') ?? false) {
    return;
  }
  final write = level == 'ERROR' ? qlogerr : qlog;
  final prefix = '${DateTime.now()} [$level] LetsEncrypt >';
  if (message != null) {
    write('$prefix $message');
  }
  if (error != null) {
    write('$prefix $error');
  }
  if (stackTrace != null) {
    write('$prefix $stackTrace');
  }
}
