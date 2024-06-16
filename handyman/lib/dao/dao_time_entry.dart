import '../entity/task.dart';
import '../entity/time_entry.dart';
import 'dao.dart';

class DaoTimeEntry extends Dao<TimeEntry> {
  @override
  TimeEntry fromMap(Map<String, dynamic> map) => TimeEntry.fromMap(map);

  @override
  String get tableName => 'time_entry';

  Future<List<TimeEntry>> getByTask(Task? task) async {
    final db = getDb();
    if (task == null) {
      return [];
    }
    final results = await db.query(tableName,
        where: 'task_id = ?', whereArgs: [task.id], orderBy: 'start_time desc');
    return results.map(TimeEntry.fromMap).toList();
  }

  Future<TimeEntry?> getActiveEntry() async {
    final db = getDb();

    final results = await db.query(tableName,
        where: 'end_time is null', orderBy: 'start_time desc');
    final list = results.map(TimeEntry.fromMap);
    assert(list.length <= 1, 'There should only ever by one active entry');
    return list.firstOrNull;
  }
}
