#! /usr/bin/env dart

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:dcli_core/dcli_core.dart' as core;
import 'package:path/path.dart';

/// Used to recreate the assetlinks.json file from the current
/// key store.
/// The keystore should be in the hmb project which needs
/// to sit in the same parent directory as the handyman project.
void main() async {
  const releaseKeystorePath = '../../hmb/hmb-key.keystore';
  const releaseAlias = 'hmbkey';
  const debugKeystorePath = '../../hmb/hmb-key-debug.keystore';
  const debugAlias = 'hmb-debug-key';
  final outputFilePath = join(DartProject.self.pathToProjectRoot, 'www_root',
      '.well-known', 'assetlinks.json');

  // Settings().setVerbose(enabled: true);

  try {
    var password = ask('Release keystore password: ', hidden: true);
    // Generate SHA-256 fingerprint for the release keystore
    final releaseFingerprint =
        await getFingerprint(releaseKeystorePath, releaseAlias, password);

    password = ask('Debug keystore password: ', hidden: true);
    // Generate SHA-256 fingerprint for the debug keystore
    final debugFingerprint =
        await getFingerprint(debugKeystorePath, debugAlias, password);

    // Create the assetlinks.json content
    final assetlinksContent = '''
[
  {
    "relation": [
      "delegate_permission/common.handle_all_urls"
    ],
    "target": {
      "namespace": "android_app",
      "package_name": "dev.onepub.handyman",
      "sha256_cert_fingerprints": [
        "$releaseFingerprint"
      ]
    }
  },
  {
    "relation": [
      "delegate_permission/common.handle_all_urls"
    ],
    "target": {
      "namespace": "android_app",
      "package_name": "dev.onepub.handyman.debug",
      "sha256_cert_fingerprints": [
        "$debugFingerprint"
      ]
    }
  }
]
''';

    // Write the content to assetlinks.json
    File(outputFilePath).writeAsStringSync(assetlinksContent);
    print('Generated $outputFilePath with updated fingerprints.');
  } on FailedToGenerate catch (e) {
    printerr(red('Failed to generate fingerprints: ${e.message}'));
  }
}

Future<String?> getFingerprint(
    String keystorePath, String alias, String password) async {
  print('Generating fingerprint for $alias');

  Progress result;
  return core.withTempFileAsync((tmpFile) async {
    tmpFile.write(password);
    result = '''
keytool -list -v -storepass:file $tmpFile -keystore $keystorePath -alias $alias'''
        .start(
      progress: Progress.capture(),
      nothrow: true,
    );

    if (result.exitCode != 0) {
      throw FailedToGenerate('generation failed: ${result.lines}');
    } else {
      final output = result.lines;

      // Extract the SHA-256 fingerprint from the keytool output
      for (final line in output) {
        if (line.contains('SHA256:')) {
          return line.split('SHA256: ').last.trim();
        }
      }
    }

    throw FailedToGenerate(
        'Error: SHA-256 fingerprint not found in keytool output.');
  });
  // ignore: avoid_catches_without_on_clauses
}

class FailedToGenerate implements Exception {
  FailedToGenerate(this.message);

  String message;
}
