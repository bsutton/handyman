import 'package:flutter/material.dart';

import '../dao/dao_job.dart';
import '../entity/job.dart';

class AddEditJobScreen extends StatefulWidget {
  const AddEditJobScreen({super.key, this.job});
  final Job? job;

  @override
  AddEditJobScreenState createState() => AddEditJobScreenState();
}

class AddEditJobScreenState extends State<AddEditJobScreen> {
  late TextEditingController _summaryController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.job?.startDate ?? DateTime.now();
    _summaryController = TextEditingController(text: widget.job?.summary ?? '');
    _descriptionController =
        TextEditingController(text: widget.job?.description ?? '');
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
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
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
        customerId: null,
        startDate: _selectedDate,
        summary: _summaryController.text,
        description: _descriptionController.text,
        address: _addressController.text,
      );

      await DaoJob().update(job);
    } else {
      final job = Job.forInsert(
        customerId: null,
        startDate: _selectedDate,
        summary: _summaryController.text,
        description: _descriptionController.text,
        address: _addressController.text,
      );

      await DaoJob().insert(job);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
