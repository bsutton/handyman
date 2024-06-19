import 'package:june/june.dart';

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

  @override
  JuneStateCreator get juneRefresher => DbTimeEntryChanged.new;
}

/// Can be used to notify the UI that the time entry has changed.
/// This method is called each time the database is updated through the [Dao]
/// methods - delete, insert and update.
/// You can also for a notification by calling:
/// ```
/// DbTimeEntryChanged.notify();
/// ```
class DbTimeEntryChanged extends JuneState {
  DbTimeEntryChanged();
}
