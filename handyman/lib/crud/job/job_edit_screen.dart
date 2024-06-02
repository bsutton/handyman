import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:june/june.dart';

import '../../dao/dao_job.dart';
import '../../entity/job.dart';
import '../../widgets/rich_editor.dart';
import '../../widgets/select_customer.dart';
import '../base_full_screen/entity_edit_screen.dart';

class JobEditScreen extends StatefulWidget {
  const JobEditScreen({super.key, this.job});
  final Job? job;

  @override
  JobEditScreenState createState() => JobEditScreenState();
}

class JobEditScreenState extends State<JobEditScreen>
    implements EntityState<Job> {
  late TextEditingController _summaryController;
  // late TextEditingController _descriptionController;

  late RichEditorController _descriptionController;

  late ParchmentDocument document;

  late TextEditingController _addressController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.job?.startDate ?? DateTime.now();
    _summaryController = TextEditingController(text: widget.job?.summary ?? '');
    // _descriptionController =
    //     TextEditingController(text: widget.job?.description ?? '');

    _descriptionController = RichEditorController(
        parchmentAsJsonString: widget.job?.description ?? '');

    _addressController = TextEditingController(text: widget.job?.address ?? '');
  }

  @override
  Widget build(BuildContext context) => EntityEditScreen<Job>(
      entity: widget.job,
      entityName: 'Job',
      dao: DaoJob(),
      entityState: this,
      editor: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        JuneBuilder(
            () => SelectedCustomer()..customerId = widget.job?.customerId,
            builder: (state) => SelectCustomer(selectedCustomer: state)),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: 120,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 125, maxHeight: 64),
              child: ElevatedButton(
                onPressed: _selectDate,
                child: Text(
                  'Scheduled: ${_selectedDate.toLocal()}'.split(' ')[0],
                ),
              ),
            ),
          ),
        ),
        TextFormField(
          controller: _summaryController,
          decoration: const InputDecoration(labelText: 'Summary'),
        ),
        // ExpandChild(
        //     child:
        SizedBox(
          height: 200,
          child: RichEditor(controller: _descriptionController
              // controller: _descriptionController,
              // decoration: const InputDecoration(labelText:
              //   'Description'),
              ),
          // )
        ),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(labelText: 'Address'),
        ),
      ]));

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Future<Job> forUpdate(Job job) async => Job.forUpdate(
        entity: job,
        customerId: June.getState(SelectedCustomer.new).customerId,
        startDate: _selectedDate,
        summary: _summaryController.text,
        description: jsonEncode(_descriptionController.document),
        address: _addressController.text,
      );

  @override
  Future<Job> forInsert() async => Job.forInsert(
        customerId: June.getState(SelectedCustomer.new).customerId,
        startDate: _selectedDate,
        summary: _summaryController.text,
        description: jsonEncode(_descriptionController.document),
        address: _addressController.text,
      );
}
