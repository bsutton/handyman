// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_contact.dart';
import '../../entity/contact.dart';
import '../../entity/customer.dart';
import '../../widgets/dial_widget.dart';
import '../../widgets/mail_to_icon.dart';
import '../base_nested/nested_edit_screen.dart';

class ContactEditScreen extends StatefulWidget {
  const ContactEditScreen({required this.customer, super.key, this.contact});
  final Customer customer;
  final Contact? contact;

  @override
  _ContactEditScreenstate createState() => _ContactEditScreenstate();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Contact?>('contact', contact));
  }
}

class _ContactEditScreenstate extends State<ContactEditScreen>
    implements NestedEntityState<Contact> {
  late TextEditingController _firstNameController;
  late TextEditingController _surnameController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _landlineController;
  late TextEditingController _officeNumberController;
  late TextEditingController _emailaddressController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.contact?.firstName);
    _surnameController = TextEditingController(text: widget.contact?.surname);
    _mobileNumberController =
        TextEditingController(text: widget.contact?.mobileNumber);
    _landlineController = TextEditingController(text: widget.contact?.landLine);
    _officeNumberController =
        TextEditingController(text: widget.contact?.officeNumber);
    _emailaddressController =
        TextEditingController(text: widget.contact?.emailAddress);
  }

  @override
  Widget build(BuildContext context) => NestedEntityEditScreen<Contact>(
        entity: widget.contact,
        entityName: 'Contact',
        dao: DaoContact(),
        entityState: this,
        editor: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // add other form fields for the new fields
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: ' first Name'),
            ),
            TextFormField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: ' surname'),
            ),
            TextFormField(
              controller: _mobileNumberController,
              decoration: InputDecoration(
                labelText: ' mobile Number',
                suffixIcon: DialWidget(_mobileNumberController.text),
              ),
            ),
            TextFormField(
              controller: _landlineController,
              decoration: InputDecoration(
                labelText: ' landline',
                suffixIcon: DialWidget(_landlineController.text),
              ),
            ),
            TextFormField(
              controller: _officeNumberController,
              decoration: InputDecoration(
                labelText: ' office Number',
                suffixIcon: DialWidget(_officeNumberController.text),
              ),
            ),
            TextFormField(
              controller: _emailaddressController,
              decoration: InputDecoration(
                labelText: ' email address',
                suffixIcon: MailToIcon(_emailaddressController.text),
              ),
            ),
          ],
        ),
      );

  @override
  Future<Contact> forUpdate(Contact contact) async => Contact.forUpdate(
        entity: contact,
        customerId: widget.customer.id,
        firstName: _firstNameController.text,
        surname: _surnameController.text,
        mobileNumber: _mobileNumberController.text,
        landLine: _landlineController.text,
        officeNumber: _officeNumberController.text,
        emailAddress: _emailaddressController.text,
      );

  @override
  Future<Contact> forInsert() async => Contact.forInsert(
        customerId: widget.customer.id,
        firstName: _firstNameController.text,
        surname: _surnameController.text,
        mobileNumber: _mobileNumberController.text,
        landLine: _landlineController.text,
        officeNumber: _officeNumberController.text,
        emailAddress: _emailaddressController.text,
      );
}
