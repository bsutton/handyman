import 'package:sqflite/sqflite.dart';

import '../database_extension.dart';

Future<void> applyV6(Database db) async {
  await db.x('''
      ALTER TABLE job drop column col''');
  await db.x('''
      ALTER TABLE job add job_status integer''');
      
  await db.x('''CREATE INDEX job_status_idx ON job(job_status)''');
}
