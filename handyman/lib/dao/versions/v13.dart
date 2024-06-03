import 'package:sqflite/sqflite.dart';

import '../database_extension.dart';

Future<void> applyV13(Database db) async {
  await db.x('''
      ALTER TABLE customer_contact
      add `primary` integer;
    ''');
}
