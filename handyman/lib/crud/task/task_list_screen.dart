import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../dao/dao_task.dart';
import '../../entity/job.dart';
import '../../entity/task.dart';
import '../../widgets/hmb_text.dart';
import '../base_nested/nested_list_screen.dart';
import 'task_edit_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({required this.parent, super.key});

  final Parent<Job> parent;

  @override
  Widget build(BuildContext context) => NestedEntityListScreen<Task, Job>(
      parent: parent,
      pageTitle: 'Tasks',
      parentTitle: 'Job',
      dao: DaoTask(),
      // ignore: discarded_futures
      fetchList: () => DaoTask().getTasksByJob(parent.parent!),
      title: (entity) => Text(entity.name),
      onEdit: (task) => TaskEditScreen(job: parent.parent!, task: task),
      onDelete: (task) async => DaoTask().delete(task!.id),
      onInsert: (task) async => DaoTask().insert(task!),
      details: (task) =>
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          ]));
}
