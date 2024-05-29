// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dao/dao_customer.dart';
import '../entity/customer.dart';
import '../widgets/dial_widget.dart';
import '../widgets/mail_to.dart';

class AddEditCustomerScreen extends StatefulWidget {
  const AddEditCustomerScreen({super.key, this.customer});
  final Customer? customer;

  @override
  _AddEditCustomerScreenState createState() => _AddEditCustomerScreenState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Customer?>('customer', customer));
  }
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _primaryFirstNameController;
  late TextEditingController _primarySurnameController;
  late TextEditingController _primaryAddressLine1Controller;
  late TextEditingController _primaryAddressLine2Controller;
  late TextEditingController _primarySuburbController;
  late TextEditingController _primaryStateController;
  late TextEditingController _primaryPostcodeController;
  late TextEditingController _primaryMobileNumberController;
  late TextEditingController _primaryLandlineController;
  late TextEditingController _primaryOfficeNumberController;
  late TextEditingController _primaryEmailAddressController;
  late TextEditingController _secondaryFirstNameController;
  late TextEditingController _secondarySurnameController;
  late TextEditingController _secondaryAddressLine1Controller;
  late TextEditingController _secondaryAddressLine2Controller;
  late TextEditingController _secondarySuburbController;
  late TextEditingController _secondaryStateController;
  late TextEditingController _secondaryPostcodeController;
  late TextEditingController _secondaryMobileNumberController;
  late TextEditingController _secondaryLandlineController;
  late TextEditingController _secondaryOfficeNumberController;
  late TextEditingController _secondaryEmailAddressController;
  late TextEditingController _disbarredController;
  late TextEditingController _customerTypeController;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _nameController = TextEditingController(text: widget.customer!.name);
      _primaryFirstNameController =
          TextEditingController(text: widget.customer!.primaryFirstName);
      _primarySurnameController =
          TextEditingController(text: widget.customer!.primarySurname);
      _primaryAddressLine1Controller =
          TextEditingController(text: widget.customer!.primaryAddressLine1);
      _primaryAddressLine2Controller =
          TextEditingController(text: widget.customer!.primaryAddressLine2);
      _primarySuburbController =
          TextEditingController(text: widget.customer!.primarySuburb);
      _primaryStateController =
          TextEditingController(text: widget.customer!.primaryState);
      _primaryPostcodeController =
          TextEditingController(text: widget.customer!.primaryPostcode);
      _primaryMobileNumberController =
          TextEditingController(text: widget.customer!.primaryMobileNumber);
      _primaryLandlineController =
          TextEditingController(text: widget.customer!.primaryLandLine);
      _primaryOfficeNumberController =
          TextEditingController(text: widget.customer!.primaryOfficeNumber);
      _primaryEmailAddressController =
          TextEditingController(text: widget.customer!.primaryEmailAddress);
      _secondaryFirstNameController =
          TextEditingController(text: widget.customer!.secondaryFirstName);
      _secondarySurnameController =
          TextEditingController(text: widget.customer!.secondarySurname);
      _secondaryAddressLine1Controller =
          TextEditingController(text: widget.customer!.secondaryAddressLine1);
      _secondaryAddressLine2Controller =
          TextEditingController(text: widget.customer!.secondaryAddressLine2);
      _secondarySuburbController =
          TextEditingController(text: widget.customer!.secondarySuburb);
      _secondaryStateController =
          TextEditingController(text: widget.customer!.secondaryState);
      _secondaryPostcodeController =
          TextEditingController(text: widget.customer!.secondaryPostcode);
      _secondaryMobileNumberController =
          TextEditingController(text: widget.customer!.secondaryMobileNumber);
      _secondaryLandlineController =
          TextEditingController(text: widget.customer!.secondaryLandLine);
      _secondaryOfficeNumberController =
          TextEditingController(text: widget.customer!.secondaryOfficeNumber);
      _secondaryEmailAddressController =
          TextEditingController(text: widget.customer!.secondaryEmailAddress);
      _disbarredController =
          TextEditingController(text: widget.customer!.disbarred.toString());
      _customerTypeController =
          TextEditingController(text: widget.customer!.customerType.toString());
    } else {
      _nameController = TextEditingController();
      _primaryFirstNameController = TextEditingController();
      _primarySurnameController = TextEditingController();
      _primaryAddressLine1Controller = TextEditingController();
      _primaryAddressLine2Controller = TextEditingController();
      _primarySuburbController = TextEditingController();
      _primaryStateController = TextEditingController();
      _primaryPostcodeController = TextEditingController();
      _primaryMobileNumberController = TextEditingController();
      _primaryLandlineController = TextEditingController();
      _primaryOfficeNumberController = TextEditingController();
      _primaryEmailAddressController = TextEditingController();
      _secondaryFirstNameController = TextEditingController();
      _secondarySurnameController = TextEditingController();
      _secondaryAddressLine1Controller = TextEditingController();
      _secondaryAddressLine2Controller = TextEditingController();
      _secondarySuburbController = TextEditingController();
      _secondaryStateController = TextEditingController();
      _secondaryPostcodeController = TextEditingController();
      _secondaryMobileNumberController = TextEditingController();
      _secondaryLandlineController = TextEditingController();
      _secondaryOfficeNumberController = TextEditingController();
      _secondaryEmailAddressController = TextEditingController();
      _disbarredController = TextEditingController();
      _customerTypeController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title:
              Text(widget.customer != null ? 'Edit Customer' : 'Add Customer'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: onEnterKey(
            onPressed: (context) async => onSave(),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    // Add other form fields for the new fields
                    TextFormField(
                      controller: _primaryFirstNameController,
                      decoration: const InputDecoration(
                          labelText: 'Primary First Name'),
                    ),
                    TextFormField(
                      controller: _primarySurnameController,
                      decoration:
                          const InputDecoration(labelText: 'Primary Surname'),
                    ),
                    TextFormField(
                      controller: _primaryAddressLine1Controller,
                      decoration: const InputDecoration(
                          labelText: 'Primary Address Line 1'),
                    ),
                    TextFormField(
                      controller: _primaryAddressLine2Controller,
                      decoration: const InputDecoration(
                          labelText: 'Primary Address Line 2'),
                    ),
                    TextFormField(
                      controller: _primarySuburbController,
                      decoration:
                          const InputDecoration(labelText: 'Primary Suburb'),
                    ),
                    TextFormField(
                      controller: _primaryStateController,
                      decoration:
                          const InputDecoration(labelText: 'Primary State'),
                    ),
                    TextFormField(
                      controller: _primaryPostcodeController,
                      decoration:
                          const InputDecoration(labelText: 'Primary Postcode'),
                    ),
                    TextFormField(
                      controller: _primaryMobileNumberController,
                      decoration: InputDecoration(
                        labelText: 'Primary Mobile Number',
                        suffixIcon:
                            DialWidget(_primaryMobileNumberController.text),
                      ),
                    ),
                    TextFormField(
                      controller: _primaryLandlineController,
                      decoration: InputDecoration(
                        labelText: 'Primary Landline',
                        suffixIcon: DialWidget(_primaryLandlineController.text),
                      ),
                    ),
                    TextFormField(
                      controller: _primaryOfficeNumberController,
                      decoration: InputDecoration(
                        labelText: 'Primary Office Number',
                        suffixIcon:
                            DialWidget(_primaryOfficeNumberController.text),
                      ),
                    ),
                    TextFormField(
                      controller: _primaryEmailAddressController,
                      decoration: InputDecoration(
                        labelText: 'Primary Email Address',
                        suffixIcon:
                            MailToWidget(_primaryEmailAddressController.text),
                      ),
                    ),
                    TextFormField(
                      controller: _secondaryFirstNameController,
                      decoration: const InputDecoration(
                          labelText: 'Secondary First Name'),
                    ),
                    TextFormField(
                      controller: _secondarySurnameController,
                      decoration:
                          const InputDecoration(labelText: 'Secondary Surname'),
                    ),
                    TextFormField(
                      controller: _secondaryAddressLine1Controller,
                      decoration: const InputDecoration(
                          labelText: 'Secondary Address Line 1'),
                    ),
                    TextFormField(
                      controller: _secondaryAddressLine2Controller,
                      decoration: const InputDecoration(
                          labelText: 'Secondary Address Line 2'),
                    ),
                    TextFormField(
                      controller: _secondarySuburbController,
                      decoration:
                          const InputDecoration(labelText: 'Secondary Suburb'),
                    ),
                    TextFormField(
                      controller: _secondaryStateController,
                      decoration:
                          const InputDecoration(labelText: 'Secondary State'),
                    ),
                    TextFormField(
                      controller: _secondaryPostcodeController,
                      decoration: const InputDecoration(
                          labelText: 'Secondary Postcode'),
                    ),
                    TextFormField(
                      controller: _secondaryMobileNumberController,
                      decoration: InputDecoration(
                          labelText: 'Secondary Mobile Number',
                          suffixIcon: DialWidget(
                              _secondaryMobileNumberController.text)),
                    ),
                    TextFormField(
                      controller: _secondaryLandlineController,
                      decoration: InputDecoration(
                          labelText: 'Secondary Landline',
                          suffixIcon:
                              DialWidget(_secondaryLandlineController.text)),
                    ),
                    TextFormField(
                      controller: _secondaryOfficeNumberController,
                      decoration: InputDecoration(
                          labelText: 'Secondary Office Number',
                          suffixIcon: DialWidget(
                              _secondaryOfficeNumberController.text)),
                    ),
                    TextFormField(
                        controller: _secondaryEmailAddressController,
                        decoration: InputDecoration(
                            labelText: 'Secondary Email Address',
                            suffixIcon: MailToWidget(
                                _secondaryEmailAddressController.text))),
                    TextFormField(
                      controller: _disbarredController,
                      decoration: const InputDecoration(labelText: 'Disbarred'),
                    ),
                    TextFormField(
                      controller: _customerTypeController,
                      decoration:
                          const InputDecoration(labelText: 'Customer Type'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                            child: const Text('Cancel'),
                            onPressed: () async => onCancel()),
                        const SizedBox(width: 16),
                        ElevatedButton(
                            child: const Text('Save'),
                            onPressed: () async => onSave()),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  void onCancel() {
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> onSave() async {
    if (_formKey.currentState!.validate()) {
      if (widget.customer != null) {
        // Editing existing customer
        final customer = Customer.forUpdate(
            entity: widget.customer!,
            name: _nameController.text,
            primaryFirstName: _primaryFirstNameController.text,
            primarySurname: _primarySurnameController.text,
            primaryAddressLine1: _primaryAddressLine1Controller.text,
            primaryAddressLine2: _primaryAddressLine2Controller.text,
            primarySuburb: _primarySuburbController.text,
            primaryState: _primaryStateController.text,
            primaryPostcode: _primaryPostcodeController.text,
            primaryMobileNumber: _primaryMobileNumberController.text,
            primaryLandLine: _primaryLandlineController.text,
            primaryOfficeNumber: _primaryOfficeNumberController.text,
            primaryEmailAddress: _primaryEmailAddressController.text,
            secondaryFirstName: _secondaryFirstNameController.text,
            secondarySurname: _secondarySurnameController.text,
            secondaryAddressLine1: _secondaryAddressLine1Controller.text,
            secondaryAddressLine2: _secondaryAddressLine2Controller.text,
            secondarySuburb: _secondarySuburbController.text,
            secondaryState: _secondaryStateController.text,
            secondaryPostcode: _secondaryPostcodeController.text,
            secondaryMobileNumber: _secondaryMobileNumberController.text,
            secondaryLandLine: _secondaryLandlineController.text,
            secondaryOfficeNumber: _secondaryOfficeNumberController.text,
            secondaryEmailAddress: _secondaryEmailAddressController.text,
            disbarred: _disbarredController.text.toLowerCase() == 'true',
            customerType: CustomerType.residential);

        await DaoCustomer().update(customer);
      } else {
        // Adding new customer
        final customer = Customer.forInsert(
            name: _nameController.text,
            primaryFirstName: _primaryFirstNameController.text,
            primarySurname: _primarySurnameController.text,
            primaryAddressLine1: _primaryAddressLine1Controller.text,
            primaryAddressLine2: _primaryAddressLine2Controller.text,
            primarySuburb: _primarySuburbController.text,
            primaryState: _primaryStateController.text,
            primaryPostcode: _primaryPostcodeController.text,
            primaryMobileNumber: _primaryMobileNumberController.text,
            primaryLandLine: _primaryLandlineController.text,
            primaryOfficeNumber: _primaryOfficeNumberController.text,
            primaryEmailAddress: _primaryEmailAddressController.text,
            secondaryFirstName: _secondaryFirstNameController.text,
            secondarySurname: _secondarySurnameController.text,
            secondaryAddressLine1: _secondaryAddressLine1Controller.text,
            secondaryAddressLine2: _secondaryAddressLine2Controller.text,
            secondarySuburb: _secondarySuburbController.text,
            secondaryState: _secondaryStateController.text,
            secondaryPostcode: _secondaryPostcodeController.text,
            secondaryMobileNumber: _secondaryMobileNumberController.text,
            secondaryLandLine: _secondaryLandlineController.text,
            secondaryOfficeNumber: _secondaryOfficeNumberController.text,
            secondaryEmailAddress: _secondaryEmailAddressController.text,
            disbarred: _disbarredController.text.toLowerCase() == 'true',
            customerType: CustomerType.residential);

        await DaoCustomer().insert(customer);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Widget onEnterKey(
          {required Widget child,
          required void Function(BuildContext context) onPressed}) =>
      KeyboardListener(
        focusNode: FocusNode(), // Ensure that the RawKeyboardListener
        // receives key events
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            // Handle Enter key press here
            // For example, call onPressed for the RaisedButton
            onPressed(context);
          }
        },
        child: child,
      );
}
