import 'package:sqflite/sqflite.dart';

import '../database_extension.dart';

Future<void> applyV14(Database db) async {
  await db.x('''
      ALTER TABLE customer_site
      add `primary` integer;
    ''');
}
