// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_supplier.dart';
import '../../entity/supplier.dart';
import '../../widgets/dial_widget.dart';
import '../../widgets/mail_to.dart';
import '../base/entity_edit_screen.dart';

class SupplierEditScreen extends StatefulWidget {
  const SupplierEditScreen({super.key, this.supplier});
  final Supplier? supplier;

  @override
  _SupplierEditScreenState createState() => _SupplierEditScreenState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Supplier?>('supplier', supplier));
  }
}

class _SupplierEditScreenState extends State<SupplierEditScreen>
    implements EntityState<Supplier> {
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supplier?.name);
    _primaryFirstNameController =
        TextEditingController(text: widget.supplier?.primaryFirstName);
    _primarySurnameController =
        TextEditingController(text: widget.supplier?.primarySurname);
    _primaryAddressLine1Controller =
        TextEditingController(text: widget.supplier?.primaryAddressLine1);
    _primaryAddressLine2Controller =
        TextEditingController(text: widget.supplier?.primaryAddressLine2);
    _primarySuburbController =
        TextEditingController(text: widget.supplier?.primarySuburb);
    _primaryStateController =
        TextEditingController(text: widget.supplier?.primaryState);
    _primaryPostcodeController =
        TextEditingController(text: widget.supplier?.primaryPostcode);
    _primaryMobileNumberController =
        TextEditingController(text: widget.supplier?.primaryMobileNumber);
    _primaryLandlineController =
        TextEditingController(text: widget.supplier?.primaryLandLine);
    _primaryOfficeNumberController =
        TextEditingController(text: widget.supplier?.primaryOfficeNumber);
    _primaryEmailAddressController =
        TextEditingController(text: widget.supplier?.primaryEmailAddress);
    _secondaryFirstNameController =
        TextEditingController(text: widget.supplier?.secondaryFirstName);
    _secondarySurnameController =
        TextEditingController(text: widget.supplier?.secondarySurname);
    _secondaryAddressLine1Controller =
        TextEditingController(text: widget.supplier?.secondaryAddressLine1);
    _secondaryAddressLine2Controller =
        TextEditingController(text: widget.supplier?.secondaryAddressLine2);
    _secondarySuburbController =
        TextEditingController(text: widget.supplier?.secondarySuburb);
    _secondaryStateController =
        TextEditingController(text: widget.supplier?.secondaryState);
    _secondaryPostcodeController =
        TextEditingController(text: widget.supplier?.secondaryPostcode);
    _secondaryMobileNumberController =
        TextEditingController(text: widget.supplier?.secondaryMobileNumber);
    _secondaryLandlineController =
        TextEditingController(text: widget.supplier?.secondaryLandLine);
    _secondaryOfficeNumberController =
        TextEditingController(text: widget.supplier?.secondaryOfficeNumber);
    _secondaryEmailAddressController =
        TextEditingController(text: widget.supplier?.secondaryEmailAddress);
  }

  @override
  Widget build(BuildContext context) => EntityEditScreen<Supplier>(
        entity: widget.supplier,
        entityName: 'Supplier',
        dao: DaoSupplier(),
        entityState: this,
        editor: Column(
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
              decoration:
                  const InputDecoration(labelText: 'Primary First Name'),
            ),
            TextFormField(
              controller: _primarySurnameController,
              decoration: const InputDecoration(labelText: 'Primary Surname'),
            ),
            TextFormField(
              controller: _primaryAddressLine1Controller,
              decoration:
                  const InputDecoration(labelText: 'Primary Address Line 1'),
            ),
            TextFormField(
              controller: _primaryAddressLine2Controller,
              decoration:
                  const InputDecoration(labelText: 'Primary Address Line 2'),
            ),
            TextFormField(
              controller: _primarySuburbController,
              decoration: const InputDecoration(labelText: 'Primary Suburb'),
            ),
            TextFormField(
              controller: _primaryStateController,
              decoration: const InputDecoration(labelText: 'Primary State'),
            ),
            TextFormField(
              controller: _primaryPostcodeController,
              decoration: const InputDecoration(labelText: 'Primary Postcode'),
            ),
            TextFormField(
              controller: _primaryMobileNumberController,
              decoration: InputDecoration(
                labelText: 'Primary Mobile Number',
                suffixIcon: DialWidget(_primaryMobileNumberController.text),
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
                suffixIcon: DialWidget(_primaryOfficeNumberController.text),
              ),
            ),
            TextFormField(
              controller: _primaryEmailAddressController,
              decoration: InputDecoration(
                labelText: 'Primary Email Address',
                suffixIcon: MailToWidget(_primaryEmailAddressController.text),
              ),
            ),
            TextFormField(
              controller: _secondaryFirstNameController,
              decoration:
                  const InputDecoration(labelText: 'Secondary First Name'),
            ),
            TextFormField(
              controller: _secondarySurnameController,
              decoration: const InputDecoration(labelText: 'Secondary Surname'),
            ),
            TextFormField(
              controller: _secondaryAddressLine1Controller,
              decoration:
                  const InputDecoration(labelText: 'Secondary Address Line 1'),
            ),
            TextFormField(
              controller: _secondaryAddressLine2Controller,
              decoration:
                  const InputDecoration(labelText: 'Secondary Address Line 2'),
            ),
            TextFormField(
              controller: _secondarySuburbController,
              decoration: const InputDecoration(labelText: 'Secondary Suburb'),
            ),
            TextFormField(
              controller: _secondaryStateController,
              decoration: const InputDecoration(labelText: 'Secondary State'),
            ),
            TextFormField(
              controller: _secondaryPostcodeController,
              decoration:
                  const InputDecoration(labelText: 'Secondary Postcode'),
            ),
            TextFormField(
              controller: _secondaryMobileNumberController,
              decoration: InputDecoration(
                  labelText: 'Secondary Mobile Number',
                  suffixIcon:
                      DialWidget(_secondaryMobileNumberController.text)),
            ),
            TextFormField(
              controller: _secondaryLandlineController,
              decoration: InputDecoration(
                  labelText: 'Secondary Landline',
                  suffixIcon: DialWidget(_secondaryLandlineController.text)),
            ),
            TextFormField(
              controller: _secondaryOfficeNumberController,
              decoration: InputDecoration(
                  labelText: 'Secondary Office Number',
                  suffixIcon:
                      DialWidget(_secondaryOfficeNumberController.text)),
            ),
            TextFormField(
                controller: _secondaryEmailAddressController,
                decoration: InputDecoration(
                    labelText: 'Secondary Email Address',
                    suffixIcon:
                        MailToWidget(_secondaryEmailAddressController.text))),
          ],
        ),
      );

  @override
  Future<Supplier> forUpdate(Supplier supplier) async => Supplier.forUpdate(
      entity: supplier,
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
      secondaryEmailAddress: _secondaryEmailAddressController.text);

  @override
  Future<Supplier> forInsert() async => Supplier.forInsert(
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
      secondaryEmailAddress: _secondaryEmailAddressController.text);
}
