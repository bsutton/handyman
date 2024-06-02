import 'package:sqflite/sqflite.dart';

import 'v1.dart';
import 'v2.dart';
import 'v3.dart';
import 'v4.dart';
import 'v5.dart';
import 'v6.dart';
import 'v7.dart';
import 'v8.dart';

final Map<int, Future<void> Function(Database)?> upgrades = {
  8: applyV8,
  7: applyV7,
  6: applyV6,
  5: applyV5,
  4: applyV4,
  3: applyV3,
  2: applyV2,
  1: applyV1
};

Future<void> upgradeDb(Database db, int oldVersion, int newVersion) async {
  if (oldVersion == 1) {
    print('Creating database');
  } else {
    print('Upgrade database from Version $oldVersion');
  }
  for (var version = oldVersion + 1; version <= newVersion; version++) {
    print('Upgrading to $version');
    await upgrades[version]?.call(db);
  }
}

Future<void> x(Database db, String command) async {
  await db.execute(command);
}
