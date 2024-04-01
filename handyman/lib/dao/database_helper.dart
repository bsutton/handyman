import 'dart:async';

import 'package:handyman/dao/dao_customer.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Database get database {
    return _database!;
  }

  static Future<void> initDatabase() async {
    /// required for non-mobile platforms.
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;
    String path = join(await getDatabasesPath(), 'customer_database.db');
    _database = await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    DaoCustomer().createTable(db, version);
  }
}
