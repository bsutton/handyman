import 'package:flutter/material.dart';

import '../../dao/dao_system.dart';
import '../../entity/system.dart';

class SystemEditScreen extends StatefulWidget {
  const SystemEditScreen({required this.system, super.key});
  final System system;

  @override
  // ignore: library_private_types_in_public_api
  _SystemEditScreenState createState() => _SystemEditScreenState();
}

class _SystemEditScreenState extends State<SystemEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fromEmailController;
  late TextEditingController _bsbController;
  late TextEditingController _accountNoController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _suburbController;
  late TextEditingController _stateController;
  late TextEditingController _postcodeController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _landLineController;
  late TextEditingController _officeNumberController;
  late TextEditingController _emailAddressController;
  late TextEditingController _webUrlController;

  @override
  void initState() {
    super.initState();
    _fromEmailController = TextEditingController(text: widget.system.fromEmail);
    _bsbController = TextEditingController(text: widget.system.bsb);
    _accountNoController = TextEditingController(text: widget.system.accountNo);
    _addressLine1Controller =
        TextEditingController(text: widget.system.addressLine1);
    _addressLine2Controller =
        TextEditingController(text: widget.system.addressLine2);
    _suburbController = TextEditingController(text: widget.system.suburb);
    _stateController = TextEditingController(text: widget.system.state);
    _postcodeController = TextEditingController(text: widget.system.postcode);
    _mobileNumberController =
        TextEditingController(text: widget.system.mobileNumber);
    _landLineController = TextEditingController(text: widget.system.landLine);
    _officeNumberController =
        TextEditingController(text: widget.system.officeNumber);
    _emailAddressController =
        TextEditingController(text: widget.system.emailAddress);
    _webUrlController = TextEditingController(text: widget.system.webUrl);
  }

  @override
  void dispose() {
    _fromEmailController.dispose();
    _bsbController.dispose();
    _accountNoController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _suburbController.dispose();
    _stateController.dispose();
    _postcodeController.dispose();
    _mobileNumberController.dispose();
    _landLineController.dispose();
    _officeNumberController.dispose();
    _emailAddressController.dispose();
    _webUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      // Save the form data
      widget.system.fromEmail = _fromEmailController.text;
      widget.system.bsb = _bsbController.text;
      widget.system.accountNo = _accountNoController.text;
      widget.system.addressLine1 = _addressLine1Controller.text;
      widget.system.addressLine2 = _addressLine2Controller.text;
      widget.system.suburb = _suburbController.text;
      widget.system.state = _stateController.text;
      widget.system.postcode = _postcodeController.text;
      widget.system.mobileNumber = _mobileNumberController.text;
      widget.system.landLine = _landLineController.text;
      widget.system.officeNumber = _officeNumberController.text;
      widget.system.emailAddress = _emailAddressController.text;
      widget.system.webUrl = _webUrlController.text;

      await DaoSystem().update(widget.system);

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit System Entity'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveForm,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _fromEmailController,
                  decoration: const InputDecoration(labelText: 'From Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a from email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _bsbController,
                  decoration: const InputDecoration(labelText: 'BSB'),
                ),
                TextFormField(
                  controller: _accountNoController,
                  decoration:
                      const InputDecoration(labelText: 'Account Number'),
                ),
                TextFormField(
                  controller: _addressLine1Controller,
                  decoration:
                      const InputDecoration(labelText: 'Address Line 1'),
                ),
                TextFormField(
                  controller: _addressLine2Controller,
                  decoration:
                      const InputDecoration(labelText: 'Address Line 2'),
                ),
                TextFormField(
                  controller: _suburbController,
                  decoration: const InputDecoration(labelText: 'Suburb'),
                ),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                ),
                TextFormField(
                  controller: _postcodeController,
                  decoration: const InputDecoration(labelText: 'Postcode'),
                ),
                TextFormField(
                  controller: _mobileNumberController,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                ),
                TextFormField(
                  controller: _landLineController,
                  decoration: const InputDecoration(labelText: 'Land Line'),
                ),
                TextFormField(
                  controller: _officeNumberController,
                  decoration: const InputDecoration(labelText: 'Office Number'),
                ),
                TextFormField(
                  controller: _emailAddressController,
                  decoration:
                      const InputDecoration(labelText: 'To Email Address'),
                ),
                TextFormField(
                  controller: _webUrlController,
                  decoration: const InputDecoration(labelText: 'Web URL'),
                ),
              ],
            ),
          ),
        ),
      );
}
