import 'package:shelf_letsencrypt/shelf_letsencrypt.dart';

/// Include the HMB endpoint for existing Handyman installations without
/// requesting production certificates from a development host.
List<String> certificateDomainNames(
  String primary, {
  List<String>? additional,
}) => {
  primary,
  ...?additional,
  if (additional == null &&
      (primary == 'ivanhoehandyman.com.au' ||
          primary == 'www.ivanhoehandyman.com.au'))
    'hmb.ivanhoehandyman.com.au',
}.toList();

/// The upstream validator only accepts up to three DNS labels.
class CertificateDomain extends Domain {
  const CertificateDomain({required super.name, required super.email});

  static final _hostname = RegExp(
    r'^(?:[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+'
    r'[A-Za-z]{2,63}$',
  );

  @override
  bool get isValidName => name.length <= 253 && _hostname.hasMatch(name);
}
