import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'dao_customer.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static late Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database get database => _database!;

  static Future<void> initDatabase() async {
    /// required for non-mobile platforms.
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;
    final path = join(await getDatabasesPath(), 'customer_database.db');
    _database = await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await DaoCustomer().createTable(db, version);
  }
}
