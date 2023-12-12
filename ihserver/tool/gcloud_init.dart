import 'package:dcli/dcli.dart';

void main() {

  /// reference:
  /// https://cloud.google.com/certificate-manager/docs/certificates#cert-lb-auth
  /// Create domain auths
  'gcloud certificate-manager dns-authorizations create ivanhoe-handyman'
          ' --domain="ivanhoehandyman.com.au"'
      .run;
  'gcloud certificate-manager dns-authorizations create www-ivanhoe-handyman'
          ' --domain="www.ivanhoehandyman.com.au"'
      .run;

  /// now manually add the cname records returned by running:
  ///
  ///
  'gcloud certificate-manager dns-authorizations describe ivanhoe-handyman'.run;
  'gcloud certificate-manager dns-authorizations describe www-ivanhoe-handyman'
      .run;

  /// Create certificates
  'gcloud certificate-manager certificates create ivanhoe-handyman-services '
          ' --domains="ivanhoehandyman.com.au,www.ivanhoehandyman.com.au" '
          ' --dns-authorizations="ivanhoe-handyman,www-ivanhoe-handyman"'
      .run;
}
