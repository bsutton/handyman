import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class Transaction {
  Database? db;

  Transaction() : db = DatabaseHelper.instance.database;
}
