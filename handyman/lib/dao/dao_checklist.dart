import 'package:sqflite/sqflite.dart';

import '../entity/check_list.dart';
import '../entity/task.dart';
import 'dao.dart';
import 'dao_check_list_task.dart';

class DaoCheckList extends Dao<CheckList> {
  Future<void> createTable(Database db, int version) async {}

  @override
  CheckList fromMap(Map<String, dynamic> map) => CheckList.fromMap(map);

  @override
  String get tableName => 'check_list';

  Future<CheckList?> getByTask(Task? task) async {
    final db = getDb();

    if (task == null) {
      return null;
    }
    final data = await db.rawQuery('''
select cl.* 
from check_list cl
join task_check_list jc
  on cl.id = jc.check_list_id
join task jo
  on jc.task_id = jo.id
where jo.id =? 
''', [task.id]);

    final list = toList(data);

    if (list.isEmpty) {
      return null;
    }
    return list.first;
  }

  Future<void> deleteFromTask(CheckList checklist, Task task) async {
    await DaoCheckListTask().deleteJoin(task, checklist);
    await delete(checklist.id);
  }

  Future<void> insertForTask(CheckList checklist, Task task) async {
    await insert(checklist);
    await DaoCheckListTask().insertJoin(checklist, task);
  }
}