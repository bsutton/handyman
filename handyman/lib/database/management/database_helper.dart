import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../versions/db_upgrade.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static late Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database get database => _database!;

  static Future<void> initDatabase() async {
    /// required for non-mobile platforms.
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;
    final path = await pathToDatabase();
    _database = await openDatabase(path,
        version: await getLatestVersion(), onUpgrade: upgradeDb);
  }

  static Future<String> pathToDatabase() async {
    final path = join(await getDatabasesPath(), 'handyman.db');
    return path;
  }
}
