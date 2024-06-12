import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../dao/dao_task.dart';
import '../../dao/dao_task_status.dart';
import '../../dao/dao_time_entry.dart';
import '../../entity/job.dart';
import '../../entity/task.dart';
import '../../entity/time_entry.dart';
import '../../widgets/hmb_text.dart';
import '../base_nested/nested_list_screen.dart';
import '../task/task_edit_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen(
      {required this.parent, required this.extended, super.key});
  final Parent<Job> parent;
  final bool extended;

  @override
  // ignore: library_private_types_in_public_api
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final Map<int, bool> _taskTimers = {};

  @override
  Widget build(BuildContext context) => NestedEntityListScreen<Task, Job>(
        parent: widget.parent,
        pageTitle: 'Tasks',
        parentTitle: 'Job',
        dao: DaoTask(),
        // ignore: discarded_futures
        fetchList: () => DaoTask().getTasksByJob(widget.parent.parent!),
        title: (entity) => Text(entity.name),
        onEdit: (task) => TaskEditScreen(job: widget.parent.parent!, task: task),
        onDelete: (task) async => DaoTask().delete(task!.id),
        onInsert: (task) async => DaoTask().insert(task!),
        details: (task) => 
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FutureBuilderEx(
              // ignore: discarded_futures
              future: DaoTaskStatus().getById(task.taskStatusId),
              builder: (context, status) => Text(status?.name ?? 'Not Set')),
            FutureBuilderEx(
              // ignore: discarded_futures
              future: DaoTask().getTaskStatistics(task),
              builder: (context, taskStatistics) => Row(
                children: [
                  HMBText(
                      'Effort(hrs): ${taskStatistics!.completedEffort.format('0.00')}/${taskStatistics.totalEffort.format('0.00')}'),
                  HMBText(
                      ' Earnings: ${taskStatistics.earnedCost}/${taskStatistics.totalCost}')
                ],
              ),
            ),
            Text('Completed: ${task.completed}'),
            IconButton(
              icon: Icon(_taskTimers[task.id] ?? false
                  ? Icons.stop
                  : Icons.play_arrow),
              onPressed: () async => _toggleTimer(task),
            ),
          ],
        ),
      );

  /// Start/Stop the Time entry timer.
  Future<void> _toggleTimer(Task task) async {
    if (_taskTimers[task.id] ?? false) {
      // Stop timer
      final daoTimeEntry = DaoTimeEntry();
      final timeEntries = await daoTimeEntry.getByTask(task);
      final ongoingEntry =
          timeEntries.firstWhere((entry) => entry.endTime == null);
      final updatedEntry = TimeEntry.forUpdate(
          entity: ongoingEntry,
          taskId: task.id,
          startTime: ongoingEntry.startTime,
          endTime: DateTime.now());
      await daoTimeEntry.update(updatedEntry);
      setState(() {
        _taskTimers[task.id] = false;
      });
    } else {
      // Start timer
      final newEntry =
          TimeEntry.forInsert(taskId: task.id, startTime: DateTime.now());
      await DaoTimeEntry().insert(newEntry);
      setState(() {
        _taskTimers[task.id] = true;
      });
    }
  }
}
