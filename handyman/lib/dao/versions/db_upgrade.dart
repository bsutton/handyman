import 'package:sqflite/sqflite.dart';

import '../management/database_helper.dart';
import '../management/db_backup.dart';
import 'v1.dart';
import 'v10.dart';
import 'v11.dart';
import 'v12.dart';
import 'v13.dart';
import 'v14.dart';
import 'v2.dart';
import 'v3.dart';
import 'v4.dart';
import 'v5.dart';
import 'v6.dart';
import 'v7.dart';
import 'v8.dart';
import 'v9.dart';

final Map<int, Future<void> Function(Database)?> upgradeDeltas = {
  14: applyV14,
  13: applyV13,
  12: applyV12,
  11: applyV11,
  10: applyV10,
  9: applyV9,
  8: applyV8,
  7: applyV7,
  6: applyV6,
  5: applyV5,
  4: applyV4,
  3: applyV3,
  2: applyV2,
  1: applyV1
};

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
  for (var version = oldVersion + 1; version <= newVersion; version++) {
    print('Upgrading to $version');
    await upgradeDeltas[version]?.call(db);
  }
}

Future<void> x(Database db, String command) async {
  await db.execute(command);
}
