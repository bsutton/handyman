import '../entity/job.dart';
import '../entity/task.dart';
import 'dao.dart';

class DaoTask extends Dao<Task> {
  Future<List<Task>> getTasksByJob(Job job) async {
    final db = getDb();

    final results =
        await db.query(tableName, where: 'jobid = ?', whereArgs: [job.id]);

    final tasks = <Task>[];
    for (final result in results) {
      tasks.add(Task.fromMap(result));
    }
    return tasks;
  }

  @override
  Task fromMap(Map<String, dynamic> map) => Task.fromMap(map);

  @override
  String get tableName => 'tasks';
}
