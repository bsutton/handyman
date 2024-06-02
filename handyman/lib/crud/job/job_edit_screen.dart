import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../dao/dao_customer.dart';
import '../../dao/dao_job.dart';
import '../../entity/customer.dart';
import '../../entity/job.dart';
import '../../widgets/rich_editor.dart';
import '../base/entity_edit_screen.dart';

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

  Customer? selectedCustomer;

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
        FutureBuilderEx(
          // ignore: discarded_futures
          future: DaoCustomer().getById(widget.job?.customerId),
          builder: (context, initialCustomer) {
            selectedCustomer ??= initialCustomer;
            return FutureBuilderEx<List<Customer>>(
                // ignore: discarded_futures
                future: DaoCustomer().getAll(),
                builder: (context, data) => DropdownButtonFormField<Customer>(
                      value: selectedCustomer,
                      hint: const Text('Select a customer'),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCustomer = newValue;
                        });
                      },
                      items: data!
                          .map((customer) => DropdownMenuItem<Customer>(
                                value: customer,
                                child: Text(customer.name),
                              ))
                          .toList(),
                      decoration: const InputDecoration(labelText: 'Client'),
                      validator: (value) =>
                          value == null ? 'Please select a client' : null,
                    ));
          },
        ),
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
        customerId: selectedCustomer?.id,
        startDate: _selectedDate,
        summary: _summaryController.text,
        description: jsonEncode(_descriptionController.document),
        address: _addressController.text,
      );

  @override
  Future<Job> forInsert() async => Job.forInsert(
        customerId: selectedCustomer?.id,
        startDate: _selectedDate,
        summary: _summaryController.text,
        description: jsonEncode(_descriptionController.document),
        address: _addressController.text,
      );
}
