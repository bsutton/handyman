import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'versions/db_upgrade.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static late Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database get database => _database!;

  static Future<void> initDatabase() async {
    /// required for non-mobile platforms.
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;
    final path = join(await getDatabasesPath(), 'handyman.db');
    _database = await openDatabase(path,
        version: upgradeDeltas.keys.first,
        onCreate: _createDatabase,
        onUpgrade: upgradeDb);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await upgradeDb(db, 1, version);
  }
}
