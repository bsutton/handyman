import 'package:sqflite/sqflite.dart';

import 'versions/v1.dart';
import 'versions/v2.dart';
import 'versions/v3.dart';
import 'versions/v4.dart';
import 'versions/v5.dart';
import 'versions/v6.dart';

final Map<int, Future<void> Function(Database)?> upgrades = {
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
