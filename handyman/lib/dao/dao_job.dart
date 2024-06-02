import 'package:sqflite/sqflite.dart';

import '../entity/job.dart';
import 'dao.dart';

class DaoJob extends Dao<Job> {
  

  @override
  Future<int> delete(int id, [Transaction? transaction]) async {
    final db = getDb(transaction);

    // Delete tasks associated with the job
    await db.delete(
      'tasks',
      where: 'jobId = ?',
      whereArgs: [id],
    );

    // Delete the job itself
    return db.delete(
      'jobs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  String get tableName => 'job';

  @override
  Job fromMap(Map<String, dynamic> map) => Job.fromMap(map);
}
