import 'package:sqflite/sqflite.dart';

import '../database_extension.dart';

Future<void> applyV4(Database db) async {
  await db.x('''PRAGMA foreign_keys = ON;''');

  await db.x('alter table customers rename to customer');
  await db.x('alter table suppliers rename to supplier');
  await db.x('alter table jobs rename to job');
  await db.x('alter table tasks rename to task');
  await db.x('alter table job rename column customerId to customer_id');
}
