import 'package:settings_yaml/settings_yaml.dart';

class Config {
  factory Config() => _config ??= Config._();

  Config._() {
    _settings = SettingsYaml.load(pathToSettings: 'config.yaml');

    username = _settings.asString('gmail_app_username');
    password = _settings.asString('gmail_app_password');
    pathToStaticContent = _settings.asString('path_to_static_content');
    letsEncryptLive = _settings.asString('lets_encrypt_live',
        defaultValue: '/opt/ihs/letsencrypt/live');
    fqdn = _settings.asString('fqdn');
    domainEmail = _settings.asString('domain_email');
    httpsPort = _settings.asInt('https_port', defaultValue: 443);
    httpPort = _settings.asInt('http_port', defaultValue: 80);
    production = _settings.asBool('production', defaultValue: false);
  }
  static Config? _config;

  late final String username;
  late final String password;
  late final String pathToStaticContent;

  /// Path to the lets encrypt certiicates normally
  /// /etc/letsencrypt/live
  late final String letsEncryptLive;

  late final bool production;

  late final String fqdn;

  late final String domainEmail;

  late final SettingsYaml _settings;

  late final int httpPort;
  late final int httpsPort;

  String get loadedFrom => _settings.filePath;
}
