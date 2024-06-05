import 'package:sqflite/sqflite.dart';

import '../database_extension.dart';

Future<void> applyV15(Database db) async {
  await db.x('''
ALTER TABLE task  add column createdDate TEXT;
ALTER TABLE task  add column  modifiedDate TEXT;
    ''');
}
