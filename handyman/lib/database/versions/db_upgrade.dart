import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../management/database_helper.dart';
import '../management/db_backup.dart';

/// Upgrade the database by applying each upgrade script in order
/// from the db's current version to the latest version.
Future<void> upgradeDb(Database db, int oldVersion, int newVersion) async {
  if (oldVersion == 1) {
    print('Creating database');
  } else {
    print('Backing up database prior to upgrade');
    await backupDatabase(await DatabaseHelper.pathToDatabase(),
        version: oldVersion);
    print('Upgrade database from Version $oldVersion');
  }
  final upgradeAssets = await _loadPathsToUpgradeScriptAssets();

  // sort the list of upgrade script numerically after stripping
  // of the .sql extension.
  upgradeAssets.sort((a, b) => _extractVersion(a) - _extractVersion(b));

  final firstUpgrade = oldVersion + 1;

  /// find the first scrip to be applied
  var index = 0;
  for (; index < upgradeAssets.length; index++) {
    final pathToScript = upgradeAssets[index];
    final scriptVersion = _extractVersion(pathToScript);
    if (scriptVersion >= firstUpgrade) {
      print('Upgrading to $scriptVersion');
      await _executeScript(db, pathToScript);
    }
  }
}

Future<int> getLatestVersion() async {
  final upgradeAssets = await _loadPathsToUpgradeScriptAssets();

  // sort the list of upgrade script numerically after stripping
  // of the .sql extension.
  upgradeAssets.sort((a, b) => _extractVersion(a) - _extractVersion(b));

  return _extractVersion(upgradeAssets[0]);
}

Future<void> _executeScript(Database db, String pathToScript) async {
  final sql = await File(pathToScript).readAsString();

  await db.execute(sql);
}

int _extractVersion(String pathToScript) {
  final basename = basenameWithoutExtension(pathToScript);

  return int.parse(basename.substring(1));
}

Future<void> x(Database db, String command) async {
  await db.execute(command);
}

Future<List<String>> _loadPathsToUpgradeScriptAssets() async {
  final jsonString =
      await rootBundle.loadString('assets/sql/upgrade_list.json');
  return List<String>.from(json.decode(jsonString) as List);
}
