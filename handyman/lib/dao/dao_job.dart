import 'package:sqflite/sqflite.dart';
import 'package:strings/strings.dart';

import '../entity/job.dart';
import 'dao.dart';

class DaoJob extends Dao<Job> {
  @override
  Future<int> delete(int id, [Transaction? transaction]) async {
    final db = getDb(transaction);

    // Delete tasks associated with the job
    await db.delete(
      'task',
      where: 'jobId = ?',
      whereArgs: [id],
    );

    // Delete the job itself
    return db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  String get tableName => 'job';

  @override
  Job fromMap(Map<String, dynamic> map) => Job.fromMap(map);

  /// search for jobs given a user supplied filter string.
  Future<List<Job>> getByFilter(String? filter) async {
    final db = getDb();

    if (Strings.isBlank(filter)) {
      return getAll();
    }

    final likeArg = '''%$filter%''';
    final data = await db.rawQuery('''
select * 
from job j
join customer c
  on c.id = j.customer_id
join job_status js
  on j.job_status_id = js.id
where j.summary like ?
or j.description like ?
or c.name like ?
or js.name like ?
''', [likeArg, likeArg, likeArg, likeArg]);

    return toList(data);
  }
}
