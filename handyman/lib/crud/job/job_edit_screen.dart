import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:june/june.dart';

import '../../dao/dao_customer.dart';
import '../../dao/dao_job.dart';
import '../../dao/dao_job_status.dart';
import '../../entity/customer.dart';
import '../../entity/job.dart';
import '../../entity/job_status.dart';
import '../../widgets/hmb_button.dart';
import '../../widgets/hmb_child_crud_card.dart';
import '../../widgets/hmb_droplist.dart';
import '../../widgets/hmb_form_section.dart';
import '../../widgets/hmb_select_contact.dart';
import '../../widgets/hmb_select_site.dart';
import '../../widgets/hmb_text_field.dart';
import '../../widgets/rich_editor.dart';
import '../../widgets/select_customer.dart';
import '../base_full_screen/entity_edit_screen.dart';
import '../base_nested/nested_list_screen.dart';
import '../task/task_list_screen.dart';

class JobEditScreen extends StatefulWidget {
  const JobEditScreen({super.key, this.job});
  final Job? job;

  @override
  JobEditScreenState createState() => JobEditScreenState();
}

class JobEditScreenState extends State<JobEditScreen>
    implements EntityState<Job> {
  late TextEditingController _summaryController;
  late RichEditorController _descriptionController;
  late FocusNode _descriptionFocusNode;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.job?.startDate ?? DateTime.now();
    _summaryController = TextEditingController(text: widget.job?.summary ?? '');
    _descriptionController = RichEditorController(
        parchmentAsJsonString: widget.job?.description ?? '');
    _descriptionFocusNode = FocusNode();

    // Initialize SelectJobStatus state
    if (widget.job != null) {
      June.getState(SelectJobStatus.new).jobStatusId = widget.job!.jobStatusId;
    }
  }

  @override
  Widget build(BuildContext context) =>
      JuneBuilder(() => SelectedCustomer()..customerId = widget.job?.customerId,
          builder: (selectedCustomer) => FutureBuilderEx<Customer?>(
              // ignore: discarded_futures
              future: DaoCustomer().getById(selectedCustomer.customerId),

              /// get the customer
              builder: (context, customer) => EntityEditScreen<Job>(
                  entity: widget.job,
                  entityName: 'Job',
                  dao: DaoJob(),
                  entityState: this,
                  editor: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HMBFormSection(children: [
                          _chooseCustomer(),
                          _chooseStatus(),
                          _chooseDate(),
                          _showSummary(),
                          SizedBox(
                            height: 200,
                            child: RichEditor(
                                controller: _descriptionController,
                                focusNode: _descriptionFocusNode,
                                key: UniqueKey()),
                            // )
                          ),
                        ]),

                        /// allow the user to select a site for the job
                        _chooseSite(customer),

                        /// allow the user to select a contact for the job
                        _chooseContact(customer),
                        _manageTasks(),
                      ]))));

  Widget _showSummary() => HMBTextField(
        controller: _summaryController,
        labelText: 'Job Summary',
      );

  HMBChildCrudCard _manageTasks() => HMBChildCrudCard(
        headline: 'Tasks',
        crudListScreen: TaskListScreen(parent: Parent(widget.job)),
      );

  JuneBuilder<SelectedContact> _chooseContact(Customer? customer) =>
      JuneBuilder(() => SelectedContact()..contactId = widget.job?.contactId,
          builder: (state) =>
              HMBSelectContact(initialContact: state, customer: customer));

  JuneBuilder<SelectedSite> _chooseSite(Customer? customer) =>
      JuneBuilder(() => SelectedSite()..siteId = widget.job?.siteId,
          builder: (state) =>
              HMBSelectSite(initialSite: state, customer: customer));

  Widget _chooseCustomer() => SelectCustomer(
        selectedCustomer: June.getState(SelectedCustomer.new),
        onSelected: (customer) => setState(() {
          setState(() {
            June.getState(SelectedCustomer.new).customerId = customer?.id;

            /// we have changed customers so the site and contact lists
            /// are no longer valid.
            June.getState(SelectedSite.new).siteId = null;
            June.getState(SelectedContact.new).contactId = null;
          });
        }),
      );

  Widget _chooseStatus() => FutureBuilderEx(
      // ignore: discarded_futures
      future: DaoJobStatus().getAll(),
      builder: (context, list) => HMBDroplist<JobStatus>(
          labelText: 'Status',
          items: list!,
          initialValue: list.firstWhere(
              (element) =>
                  element.id == June.getState(SelectJobStatus.new).jobStatusId,
              orElse: () {
            final defaultState = list[0];
            June.getState(SelectJobStatus.new).jobStatusId = defaultState.id;
            return defaultState;
          }),
          onChanged: (status) => setState(
                () {
                  June.getState(SelectJobStatus.new).jobStatusId = status?.id;
                },
              ),
          format: (value) => value.name));

  HMBButton _chooseDate() => HMBButton(
        onPressed: _selectDate,
        label: 'Scheduled: ${_selectedDate.toLocal()}'.split(' ')[0],
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

  @override
  Future<Job> forUpdate(Job job) async => Job.forUpdate(
      entity: job,
      customerId: June.getState(SelectedCustomer.new).customerId,
      summary: _summaryController.text,
      description: jsonEncode(_descriptionController.document),
      startDate: _selectedDate,
      siteId: June.getState(SelectedSite.new).siteId,
      contactId: June.getState(SelectedContact.new).contactId,
      jobStatusId: June.getState(SelectJobStatus.new).jobStatusId);

  @override
  Future<Job> forInsert() async => Job.forInsert(
      customerId: June.getState(SelectedCustomer.new).customerId,
      summary: _summaryController.text,
      description: jsonEncode(_descriptionController.document),
      startDate: _selectedDate,
      siteId: June.getState(SelectedSite.new).siteId,
      contactId: June.getState(SelectedContact.new).contactId,
      jobStatusId: June.getState(SelectJobStatus.new).jobStatusId);

  @override
  void dispose() {
    _summaryController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }
}

class SelectJobStatus {
  SelectJobStatus();

  int? jobStatusId;
}
