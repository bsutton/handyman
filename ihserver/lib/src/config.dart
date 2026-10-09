import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:revault_api/revault_api.dart';
import 'package:settings_yaml/settings_yaml.dart';

import 'certificate_domains.dart';
import 'credentials.dart';

class Config {
  static Config? _config;

  static const hmbStartsYaml = 'hmb_starts.yaml';

  ServerCredentials? _credentials;
  final _unlocked = Completer<void>();
  bool get isUnlocked => _credentials != null;
  Future<void> get whenUnlocked => _unlocked.future;

  String get username => _credentials!.username;
  String get password => _credentials!.password;
  String get hmbApiToken => _credentials!.hmbApiToken;

  Future<void> unlock(String password) async {
    final secret = SecretString.fromString(password);
    try {
      await loadCredentials(password: secret);
    } finally {
      secret.close();
    }
  }

  String get heartbeatUrl => _settings.asString('lockbox_heartbeat_url');

  Future<void> loadCredentials({SecretString? password}) async {
    if (isUnlocked) {
      return;
    }
    final unlockMode = _settings.asString(
      'lockbox_unlock_mode',
      defaultValue: 'agent',
    );
    if (unlockMode != 'agent' && unlockMode != 'vault') {
      throw const CredentialException(CredentialFailure.mode);
    }
    final credentials = await ServerCredentials.load(
      password: password,
      useAgent: unlockMode == 'agent',
      path: _settings.asString(
        'lockbox_path',
        defaultValue: join('config', 'ihserver.lbox'),
      ),
      usernameVariable: _settings.asString(
        'gmail_username_variable',
        defaultValue: '/gmail_app_username',
      ),
      passwordVariable: _settings.asString(
        'gmail_password_variable',
        defaultValue: '/gmail_app_password',
      ),
      tokenVariable: _settings.asString(
        'hmb_token_variable',
        defaultValue: '/hmb_api_token',
      ),
    );
    if (!isUnlocked) {
      _credentials = credentials;
      _unlocked.complete();
    }
  }

  late final String pathToStaticContent;

  /// Path to the lets encrypt certiicates normally
  /// /etc/letsencrypt/live
  late final String letsEncryptLive;

  late final bool production;

  late final String fqdn;

  late final List<String> additionalFqdns;

  late final String domainEmail;

  late final SettingsYaml _settings;

  // if false we handle request via http and don't
  // start the https service.
  late final bool useHttps;

  late final int httpPort;

  late final int httpsPort;

  Uri get unlockUrl =>
      Uri(scheme: 'https', host: fqdn, port: httpsPort, path: '/unlock');

  String get unlockInstructions => useHttps
      ? 'Open $unlockUrl and enter the Lockbox password to unlock.'
      : 'HTTPS is disabled; unlock the Lockbox locally through the '
            'configured agent or vault.';

  late final String bindingAddress;

  late final String pathToLogfile;

  // if true then we are running in debug mode.
  late final bool debug;

  /// Path to store booking requests as JSON.
  late final String bookingRequestsPath;

  factory Config() => _config ??= Config._();

  Config._() {
    _settings = SettingsYaml.load(
      pathToSettings: join('config', 'config.yaml'),
    );

    pathToStaticContent = _settings.asString('path_to_static_content');
    letsEncryptLive = _settings.asString(
      'lets_encrypt_live',
      defaultValue: '/opt/ihs/letsencrypt/live',
    );
    fqdn = _settings.asString('fqdn');
    additionalFqdns = _settings.asStringList(
      'additional_fqdns',
      defaultValue: certificateDomainNames(fqdn).skip(1).toList(),
    );
    domainEmail = _settings.asString('domain_email');
    httpsPort = _settings.asInt('https_port', defaultValue: 443);
    httpPort = _settings.asInt('http_port', defaultValue: 80);
    production = _settings.asBool('production', defaultValue: false);
    useHttps = _settings.asBool('use_https');
    bindingAddress = _settings.asString('binding_address', defaultValue: '::');
    pathToLogfile = _settings.asString('logger_path', defaultValue: 'print');

    debug = _settings.asBool('debug', defaultValue: false);

    bookingRequestsPath = _settings.asString(
      'booking_requests_path',
      defaultValue: join('config', 'booking_requests.json'),
    );
  }

  /// Only explicitly approved configuration values may appear in logs.
  List<String> get startupReport {
    final lockboxPath = _settings.asString(
      'lockbox_path',
      defaultValue: join('config', 'ihserver.lbox'),
    );
    final values = <String, Object>{
      'path_to_static_content': pathToStaticContent,
      'fqdn': fqdn,
      'additional_fqdns': additionalFqdns,
      'domain_email': domainEmail,
      'use_https': useHttps,
      'binding_address': bindingAddress,
      'http_port': httpPort,
      'https_port': httpsPort,
      'production': production,
      'debug': debug,
      'lets_encrypt_live': letsEncryptLive,
      'logger_path': pathToLogfile,
      'booking_requests_path': bookingRequestsPath,
      'lockbox_path': lockboxPath,
      'lockbox_unlock_mode': _settings.asString(
        'lockbox_unlock_mode',
        defaultValue: 'agent',
      ),
      'gmail_username_variable': _settings.asString(
        'gmail_username_variable',
        defaultValue: '/gmail_app_username',
      ),
      'gmail_password_variable': _settings.asString(
        'gmail_password_variable',
        defaultValue: '/gmail_app_password',
      ),
      'hmb_token_variable': _settings.asString(
        'hmb_token_variable',
        defaultValue: '/hmb_api_token',
      ),
    };
    final configStatus = File(loadedFrom).existsSync() ? 'found' : 'MISSING';
    final configPath = jsonEncode(absolute(loadedFrom));
    final lines = <String>[
      'Loading config.yaml from: $configPath ($configStatus)',
      'Working directory: ${jsonEncode(Directory.current.path)}',
    ];
    for (final entry in values.entries) {
      final source = _settings[entry.key] == null ? 'default' : 'configured';
      lines.add('  ${entry.key}: ${jsonEncode(entry.value)} ($source)');
    }
    for (final key in ['path_to_static_content', 'fqdn', 'domain_email']) {
      if (_settings.asString(key).trim().isEmpty) {
        lines.add('ERROR: required setting "$key" is missing or empty.');
      }
    }
    lines.add(
      heartbeatUrl.isEmpty
          ? '  lockbox_heartbeat_url: missing or empty; heartbeat disabled'
          : '  lockbox_heartbeat_url: configured (value hidden)',
    );
    for (final key in [
      'gmail_app_username',
      'gmail_app_password',
      'hmb_api_token',
    ]) {
      if (_settings[key] != null) {
        lines.add(
          'WARNING: legacy "$key" is present but ignored; '
          'credentials come from the Lockbox.',
        );
      }
    }
    for (final entry in {
      'Lockbox': lockboxPath,
      'Static index': join(pathToStaticContent, 'index.html'),
    }.entries) {
      lines.add(
        '${entry.key}: ${jsonEncode(absolute(entry.value))} '
        '(${File(entry.value).existsSync() ? 'found' : 'MISSING'})',
      );
    }
    lines.add(
      'Lockbox variables are checked after unlocking; '
      'secret values are never logged.',
    );
    return lines;
  }

  String get loadedFrom => _settings.filePath;
}
