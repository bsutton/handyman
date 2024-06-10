import 'package:money2/money2.dart';

import '../entity/check_list_item.dart';
import '../entity/job.dart';
import '../entity/task.dart';
import '../util/fixed_ex.dart';
import '../util/money_ex.dart';
import 'dao.dart';

class DaoTask extends Dao<Task> {
  @override
  Task fromMap(Map<String, dynamic> map) => Task.fromMap(map);

  @override
  String get tableName => 'task';

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

  Future<TaskStatistics> getTaskStatistics(Task task) async {
    var totalEffort = Fixed.zero;
    var completedEffort = Fixed.zero;
    var totalCost = MoneyEx.zero;
    var earnedCost = MoneyEx.zero;

    if (task.completed) {
      completedEffort += task.effortInHours ?? FixedEx.zero;
      earnedCost += task.estimatedCost ?? MoneyEx.zero;
    }
    totalEffort += task.effortInHours ?? FixedEx.zero;
    totalCost += task.estimatedCost ?? MoneyEx.zero;

    return TaskStatistics(
        totalEffort: totalEffort,
        completedEffort: completedEffort,
        totalCost: totalCost,
        earnedCost: earnedCost);
  }

  Future<Task> getTaskForCheckListItem(CheckListItem item) async {
    final db = getDb();

    final data = await db.rawQuery('''
select t.* 
from check_list_item cli
join check_list cl
  on cli.check_list_id = cl.id
join task_check_list tcl
  on tcl.check_list_id = cl.id
join task t
  on tcl.task_id = t.id
where cli.id =? 
''', [item.id]);

    return toList(data).first;
  }
}

class TaskStatistics {
  TaskStatistics(
      {required this.totalEffort,
      required this.completedEffort,
      required this.totalCost,
      required this.earnedCost});
  final Fixed totalEffort;
  final Fixed completedEffort;
  final Money totalCost;
  final Money earnedCost;
}
