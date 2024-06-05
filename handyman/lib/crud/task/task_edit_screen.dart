import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_task.dart';
import '../../entity/job.dart';
import '../../entity/task.dart';
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
  // late RichEditorController _descriptionController;
  late bool _completed;
  late FocusNode _nameFocusNode;
  late FocusNode _descriptionFocusNode;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task?.name);

    // _descriptionController = RichEditorController(
    //     parchmentAsJsonString: widget.task?.description ?? '');

    _descriptionController =
        TextEditingController(text: widget.task?.description);

    _completed = widget.task?.completed ?? false;

    _nameFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_nameFocusNode);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
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
              // SizedBox(
              //   height: 200,
              //   child: RichEditor(
              //     controller: _descriptionController,
              //     key: UniqueKey(),
              //     focusNode: _descriptionFocusNode,
              //   ),
              // ),
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
        description: _descriptionController
            .text, // jsonEncode(_descriptionController.document),
        completed: _completed,
      );

  @override
  Future<Task> forInsert() async => Task.forInsert(
        jobId: widget.job.id,
        name: _nameController.text,
        description: _descriptionController
            .text, // jsonEncode(_descriptionController.document),
        completed: _completed,
      );
}
