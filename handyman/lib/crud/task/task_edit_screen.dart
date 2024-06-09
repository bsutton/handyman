import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:june/june.dart';

import '../../dao/dao_task.dart';
import '../../dao/dao_task_status.dart';
import '../../dao/join_adaptors/join_adaptor_check_list.dart';
import '../../entity/job.dart';
import '../../entity/task.dart';
import '../../entity/task_status.dart';
import '../../util/fixed_ex.dart';
import '../../util/money_ex.dart';
import '../../widgets/hmb_crud_checklist.dart';
import '../../widgets/hmb_droplist.dart';
import '../../widgets/hmb_text_area.dart';
import '../../widgets/hmb_text_field.dart';
import '../base_nested/nested_edit_screen.dart';
import '../base_nested/nested_list_screen.dart';

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
  late bool _completed;
  late FocusNode _summaryFocusNode;
  late FocusNode _descriptionFocusNode;
  late FocusNode _costFocusNode;
  late FocusNode _estimatedCostFocusNode;
  late FocusNode _effortInHoursFocusNode;
  late FocusNode _itemTypeIdFocusNode;

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

    _completed = widget.task?.completed ?? false;

    _summaryFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _costFocusNode = FocusNode();
    _estimatedCostFocusNode = FocusNode();
    _effortInHoursFocusNode = FocusNode();
    _itemTypeIdFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_summaryFocusNode);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _estimatedCostController.dispose();
    _effortInHoursController.dispose();
    _summaryFocusNode.dispose();
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
        editor: (task) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HMBTextField(
              controller: _nameController,
              focusNode: _summaryFocusNode,
              labelText: 'Summary',
              required: true,
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
              labelText: 'Effort (decimal hours)',
              keyboardType: TextInputType.number,
            ),
            _chooseTaskStatus(task),

            /// Check List CRUD
            HBMCrudCheckList<Task>(
                parent: Parent(task), daoJoin: JoinAdaptorTaskCheckList())
          ],
        ),
      );

  Widget _chooseTaskStatus(Task? task) => HMBDroplist<TaskStatus>(
      title: 'Set the Task Status',
      initialItem: () async => DaoTaskStatus().getById(task?.taskStatusId ?? 1),
      items: (filter) async => DaoTaskStatus().getByFilter(filter),
      format: (item) => item.description,
      onChanged: (item) {
        June.getState(TaskStatusState.new).taskStatusId = item.id;
      });

  @override
  Future<Task> forUpdate(Task task) async => Task.forUpdate(
      entity: task,
      jobId: widget.job.id,
      name: _nameController.text,
      description: _descriptionController.text,
      completed: _completed,
      estimatedCost: MoneyEx.tryParse(_estimatedCostController.text),
      effortInHours: FixedEx.tryParse(_effortInHoursController.text),
      taskStatusId: June.getState(TaskStatusState.new).taskStatusId!);

  @override
  Future<Task> forInsert() async => Task.forInsert(
      jobId: widget.job.id,
      name: _nameController.text,
      description: _descriptionController.text,
      completed: _completed,
      estimatedCost: MoneyEx.tryParse(_estimatedCostController.text),
      effortInHours: FixedEx.tryParse(_effortInHoursController.text),
      taskStatusId: June.getState(TaskStatusState.new).taskStatusId!);

  @override
  void refresh() {
    setState(() {});
  }
}

class TaskStatusState {
  TaskStatusState();

  int? taskStatusId;
}
