import 'package:sqflite/sqflite.dart';

import '../database_extension.dart';

Future<void> applyV2(Database db) async {
  await db.x('''
      CREATE TABLE jobs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerId INTEGER,
        startDate TEXT,
        summary TEXT,
        description TEXT,
        address TEXT
        createdDate TEXT,
        modifiedDate TEXT,
      )
    ''');

  await db.x('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        jobId INTEGER,
        name TEXT,
        description TEXT,
        completed INTEGER,
        FOREIGN KEY (jobId) REFERENCES jobs(id)
      )
    ''');
}
