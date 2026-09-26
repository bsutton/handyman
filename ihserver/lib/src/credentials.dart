import 'dart:convert';
import 'dart:io';

import 'package:revault_api/revault_api.dart';

/// Credentials are retained in process memory for SMTP and request auth.
/// These APIs require Dart strings, which cannot be securely erased.
class ServerCredentials {
  ServerCredentials._(this.username, this.password, this.hmbApiToken);

  final String username;
  final String password;
  final String hmbApiToken;

  static Future<ServerCredentials> load({
    required String path,
    required String usernameVariable,
    required String passwordVariable,
    required String tokenVariable,
    bool useAgent = true,
    SecretString? password,
  }) async {
    var failure = CredentialFailure.fileAccess;
    try {
      final file = File(path);
      if (!file.existsSync()) {
        throw const CredentialException(CredentialFailure.missingFile);
      }
      file.openSync().closeSync();
      failure = CredentialFailure.runtime;
      await Revault.load();
      failure = CredentialFailure.open;
      final lockbox = password != null
          ? Lockbox.open(path, password: password)
          : useAgent
          ? AgentSession.instance.acquireOpenLockbox(path)
          : Lockbox.open(path);
      try {
        return fromLockbox(
          lockbox,
          usernameVariable: usernameVariable,
          passwordVariable: passwordVariable,
          tokenVariable: tokenVariable,
        );
      } finally {
        lockbox.close();
      }
    } on CredentialException {
      rethrow;
    } catch (error) {
      if (failure == CredentialFailure.open) {
        throw CredentialException(classifyLockboxOpenFailure(error));
      }
      // Native errors may include sensitive data. Never forward their text.
      throw CredentialException(failure);
    }
  }

  static ServerCredentials fromLockbox(
    Lockbox lockbox, {
    required String usernameVariable,
    required String passwordVariable,
    required String tokenVariable,
  }) {
    try {
      String read(String name, CredentialFailure failure) {
        try {
          String? value;
          lockbox.withSecretVariable<void>(name, (bytes) {
            value = utf8.decode(bytes);
          });
          if (value == null || value!.trim().isEmpty) {
            throw CredentialException(failure);
          }
          return value!;
        } catch (_) {
          throw CredentialException.variable(failure, name);
        }
      }

      return ServerCredentials._(
        read(usernameVariable, CredentialFailure.username),
        read(passwordVariable, CredentialFailure.password),
        read(tokenVariable, CredentialFailure.token),
      );
    } on CredentialException {
      rethrow;
    } catch (_) {
      throw const CredentialException();
    }
  }

  @override
  String toString() => 'ServerCredentials(redacted)';
}

/// Classify native failures without forwarding their messages or guidance.
/// Most current native errors share one category, so recognize only known
/// signatures from reVault's error formatter. Unknown text stays private.
CredentialFailure classifyLockboxOpenFailure(Object error) {
  if (error is FileSystemException) {
    return CredentialFailure.openIo;
  }
  if (error is UnsupportedError || error is ArgumentError) {
    return CredentialFailure.openRuntime;
  }
  if (error is AgentLockboxNotOpenException ||
      error is LockboxCredentialUnavailableException ||
      error is VaultPassphraseUnavailableException) {
    return CredentialFailure.credentialUnavailable;
  }
  if (error is RevaultException) {
    if (error.category == 'unsupported_format_version') {
      return CredentialFailure.openFormat;
    }
    final message = error.message;
    if (message == 'open failed or payload authentication failed') {
      return CredentialFailure.openAuthentication;
    }
    if (message == 'corrupt lockbox header' ||
        message == 'corrupt lockbox page or record') {
      return CredentialFailure.openCorrupt;
    }
    if (message.startsWith('lock unavailable: ')) {
      return CredentialFailure.openLocked;
    }
    if (message.startsWith('io error: ')) {
      return CredentialFailure.openIo;
    }
    if (message.startsWith('lockbox transaction ')) {
      return CredentialFailure.openRecovery;
    }
    return CredentialFailure.openNative;
  }
  return CredentialFailure.open;
}

enum CredentialFailure {
  unknown('Check the server Lockbox configuration.'),
  missingFile(
    'The server Lockbox file does not exist. Check lockbox_path '
    'and upload the file.',
  ),
  fileAccess(
    'The service cannot read the Lockbox file. Check its permissions.',
  ),
  runtime(
    'The reVault runtime could not load. Redeploy the complete native bundle.',
  ),
  open(
    'An unrecognized error occurred while opening the Lockbox. '
    'This does not establish that the password is incorrect.',
  ),
  openAuthentication(
    'reVault could not authenticate the Lockbox. The supplied password '
    'may not match an access slot, or the encrypted data may be damaged.',
  ),
  openFormat(
    'The server reVault runtime does not support this Lockbox format. '
    'Rebuild and deploy with a compatible reVault runtime.',
  ),
  openIo(
    'reVault encountered a file access error while opening the Lockbox. '
    'Check lockbox_path, service permissions, and filesystem availability.',
  ),
  openLocked(
    'reVault could not acquire the Lockbox file lock. '
    'Check for another process holding the file open.',
  ),
  openCorrupt(
    'reVault reported a corrupt Lockbox header, page, or record. '
    'Verify the file with a compatible reVault version.',
  ),
  openRecovery(
    'reVault reported a Lockbox transaction recovery problem. '
    'Inspect the file locally with the reVault CLI.',
  ),
  openRuntime(
    'The reVault binding rejected the open operation. '
    'Check that the deployed Dart binding and native runtime are compatible.',
  ),
  openNative(
    'The reVault native runtime failed to open the Lockbox with an '
    'unclassified error. Sensitive native details were suppressed; '
    'this does not establish that the password is incorrect.',
  ),
  credentialUnavailable(
    'No saved Lockbox credential is available to the service. '
    'Unlock using the Lockbox password.',
  ),
  username(
    'The Lockbox opened, but the configured Gmail username is '
    'missing, empty, invalid UTF-8, or not a secret variable.',
  ),
  password(
    'The Lockbox opened, but the configured Gmail app password is '
    'missing, empty, invalid UTF-8, or not a secret variable.',
  ),
  token(
    'The Lockbox opened, but the configured HMB API token is '
    'missing, empty, invalid UTF-8, or not a secret variable.',
  ),
  mode('lockbox_unlock_mode must be agent or vault.');

  const CredentialFailure(this.message);
  final String message;
}

class CredentialException implements Exception {
  const CredentialException([this.failure = CredentialFailure.unknown])
    : variablePath = null;

  const CredentialException.variable(this.failure, this.variablePath);

  final CredentialFailure failure;
  final String? variablePath;

  String get message => variablePath == null
      ? failure.message
      : '${failure.message} Expected secret variable: "$variablePath".';

  @override
  String toString() => 'Unable to load ihserver credentials: $message';
}
