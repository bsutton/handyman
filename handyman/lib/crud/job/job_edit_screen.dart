import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../dao/dao_customer.dart';
import '../../dao/dao_job.dart';
import '../../entity/customer.dart';
import '../../entity/job.dart';
import '../../widgets/rich_editor.dart';

class JobEditScreen extends StatefulWidget {
  const JobEditScreen({super.key, this.job});
  final Job? job;

  @override
  JobEditScreenState createState() => JobEditScreenState();
}

class JobEditScreenState extends State<JobEditScreen> {
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.job != null ? 'Edit Job' : 'Add Job'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilderEx(
                // ignore: discarded_futures
                future: DaoCustomer().getById(widget.job?.customerId),
                builder: (context, initialCustomer) {
                  selectedCustomer ??= initialCustomer!;
                  return FutureBuilderEx<List<Customer>>(
                      // ignore: discarded_futures
                      future: DaoCustomer().getAll(),
                      builder: (context, data) =>
                          DropdownButtonFormField<Customer>(
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
                            decoration:
                                const InputDecoration(labelText: 'Client'),
                            validator: (value) =>
                                value == null ? 'Please select a client' : null,
                          ));
                },
              ),
              TextButton(
                onPressed: _selectDate,
                child: Text(
                  'Start Date: ${_selectedDate.toLocal()}'.split(' ')[0],
                ),
              ),
              TextFormField(
                controller: _summaryController,
                decoration: const InputDecoration(labelText: 'Summary'),
              ),
              RichEditor(controller: _descriptionController
                  // controller: _descriptionController,
                  // decoration: const InputDecoration(labelText:
                  //   'Description'),
                  ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveJob,
                child: Text(widget.job != null ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      );

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

  Future<void> _saveJob() async {
    if (widget.job != null) {
      final job = Job.forUpdate(
        entity: widget.job!,
        customerId: selectedCustomer?.id,
        startDate: _selectedDate,
        summary: _summaryController.text,
        description: jsonEncode(_descriptionController.document),
        address: _addressController.text,
      );

      await DaoJob().update(job);
    } else {
      final job = Job.forInsert(
        customerId: selectedCustomer?.id,
        startDate: _selectedDate,
        summary: _summaryController.text,
        description: jsonEncode(_descriptionController.document),
        address: _addressController.text,
      );

      await DaoJob().insert(job);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}