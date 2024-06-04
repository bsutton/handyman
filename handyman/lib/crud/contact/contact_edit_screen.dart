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
  // ignore: library_private_types_in_public_api
  _ContactEditScreenState createState() => _ContactEditScreenState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Contact?>('contact', contact));
  }
}

class _ContactEditScreenState extends State<ContactEditScreen>
    implements NestedEntityState<Contact> {
  late TextEditingController _firstNameController;
  late TextEditingController _surnameController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _landlineController;
  late TextEditingController _officeNumberController;
  late TextEditingController _emailaddressController;
  late FocusNode _firstNameFocusNode;

  final _formKey = GlobalKey<FormState>();

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

    _firstNameFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_firstNameFocusNode);
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _surnameController.dispose();
    _mobileNumberController.dispose();
    _landlineController.dispose();
    _officeNumberController.dispose();
    _emailaddressController.dispose();
    _firstNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      NestedEntityEditScreen<Contact, Customer>(
        entity: widget.contact,
        entityName: 'Contact',
        dao: DaoContact(),
        onInsert: (contact) async =>
            DaoContact().insertForCustomer(contact!, widget.customer),
        entityState: this,
        editor: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                focusNode: _firstNameFocusNode,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _surnameController,
                decoration: const InputDecoration(labelText: 'Surname'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the surname';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mobileNumberController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  suffixIcon: DialWidget(_mobileNumberController.text),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the mobile number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _landlineController,
                decoration: InputDecoration(
                  labelText: 'Landline',
                  suffixIcon: DialWidget(_landlineController.text),
                ),
              ),
              TextFormField(
                controller: _officeNumberController,
                decoration: InputDecoration(
                  labelText: 'Office Number',
                  suffixIcon: DialWidget(_officeNumberController.text),
                ),
              ),
              TextFormField(
                controller: _emailaddressController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  suffixIcon: MailToIcon(_emailaddressController.text),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email address';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );

  @override
  Future<Contact> forUpdate(Contact contact) async => Contact.forUpdate(
        entity: contact,
        firstName: _firstNameController.text,
        surname: _surnameController.text,
        mobileNumber: _mobileNumberController.text,
        landLine: _landlineController.text,
        officeNumber: _officeNumberController.text,
        emailAddress: _emailaddressController.text,
      );

  @override
  Future<Contact> forInsert() async => Contact.forInsert(
        firstName: _firstNameController.text,
        surname: _surnameController.text,
        mobileNumber: _mobileNumberController.text,
        landLine: _landlineController.text,
        officeNumber: _officeNumberController.text,
        emailAddress: _emailaddressController.text,
      );
}
