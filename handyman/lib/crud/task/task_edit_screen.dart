import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:june/june.dart';
import 'package:money2/money2.dart';

import '../../dao/dao_task.dart';
import '../../dao/dao_task_status.dart';
import '../../entity/job.dart';
import '../../entity/task.dart';
import '../../entity/task_status.dart';
import '../../widgets/hmb_droplist.dart';
import '../../widgets/hmb_text_area.dart';
import '../../widgets/hmb_text_field.dart';
import '../base_nested/nested_edit_screen.dart';

class TaskEditScreen extends StatefulWidget {
  const TaskEditScreen({required this.job, super.key, this.task});
  final Job job;
  final Task? task;

  @override
  // ignore: library_private_types_in_public_api
  _TaskEditScreenState createState() => _TaskEditScreenState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Task?>('task', task));
  }
}

class _TaskEditScreenState extends State<TaskEditScreen>
    implements NestedEntityState<Task> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _estimatedCostController;
  late TextEditingController _effortInHoursController;
  late TextEditingController _taskStatusIdController;
  late bool _completed;
  late FocusNode _nameFocusNode;
  late FocusNode _descriptionFocusNode;
  late FocusNode _costFocusNode;
  late FocusNode _estimatedCostFocusNode;
  late FocusNode _effortInHoursFocusNode;
  late FocusNode _itemTypeIdFocusNode;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task?.name);
    _descriptionController =
        TextEditingController(text: widget.task?.description);
    _estimatedCostController =
        TextEditingController(text: widget.task?.estimatedCost.toString());
    _effortInHoursController =
        TextEditingController(text: widget.task?.effortInHours.toString());
    _taskStatusIdController =
        TextEditingController(text: widget.task?.taskStatusId.toString());

    _completed = widget.task?.completed ?? false;

    _nameFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _costFocusNode = FocusNode();
    _estimatedCostFocusNode = FocusNode();
    _effortInHoursFocusNode = FocusNode();
    _itemTypeIdFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_nameFocusNode);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _estimatedCostController.dispose();
    _effortInHoursController.dispose();
    _taskStatusIdController.dispose();
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _costFocusNode.dispose();
    _estimatedCostFocusNode.dispose();
    _effortInHoursFocusNode.dispose();
    _itemTypeIdFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => NestedEntityEditScreen<Task, Job>(
        entity: widget.task,
        entityName: 'Task',
        dao: DaoTask(),
        onInsert: (task) async => DaoTask().insert(task!),
        entityState: this,
        editor: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HMBTextField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                labelText: 'Summary',
              ),
              HMBTextArea(
                controller: _descriptionController,
                focusNode: _descriptionFocusNode,
                labelText: 'Description',
              ),
              HMBTextField(
                controller: _estimatedCostController,
                focusNode: _estimatedCostFocusNode,
                labelText: 'Estimated Cost',
                keyboardType: TextInputType.number,
              ),
              HMBTextField(
                controller: _effortInHoursController,
                focusNode: _effortInHoursFocusNode,
                labelText: 'Effort',
                keyboardType: TextInputType.number,
              ),
              FutureBuilderEx(
                // ignore: discarded_futures
                future: DaoTaskStatus().getAll(),
                builder: (context, items) => FutureBuilderEx(
                    future:
                        // ignore: discarded_futures
                        DaoTaskStatus().getById(widget.task?.taskStatusId),
                    builder: (context, taskStatus) => HMBDroplist<TaskStatus>(
                        initialValue: taskStatus ?? items!.first,
                        labelText: 'Task Status',
                        items: items!,
                        onChanged: (item) => June.getState(TaskStatusState.new)
                            .taskStatusId = item?.id,
                        format: (taskStatus) => taskStatus.name)),
              ),
              SwitchListTile(
                title: const Text('Completed'),
                value: _completed,
                onChanged: (value) {
                  setState(() {
                    _completed = value;
                  });
                },
              ),
            ],
          ),
        ),
      );

  @override
  Future<Task> forUpdate(Task task) async => Task.forUpdate(
        entity: task,
        jobId: widget.job.id,
        name: _nameController.text,
        description: _descriptionController.text,
        completed: _completed,
        estimatedCost:
            Money.tryParse(_estimatedCostController.text, isoCode: 'AUD'),
        effortInHours: Fixed.tryParse(_effortInHoursController.text),
        taskStatusId: int.tryParse(_taskStatusIdController.text) ?? 0,
      );

  @override
  Future<Task> forInsert() async => Task.forInsert(
        jobId: widget.job.id,
        name: _nameController.text,
        description: _descriptionController.text,
        completed: _completed,
        estimatedCost:
            Money.tryParse(_estimatedCostController.text, isoCode: 'AUD'),
        effortInHours: Fixed.tryParse(_effortInHoursController.text),
        taskStatusId: int.tryParse(_taskStatusIdController.text) ?? 0,
      );
}

class TaskStatusState {
  TaskStatusState();

  int? taskStatusId;
}
