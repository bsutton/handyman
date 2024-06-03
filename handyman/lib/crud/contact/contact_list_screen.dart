import 'package:flutter/material.dart';
import 'package:strings/strings.dart';

import '../../dao/dao_contact.dart';
import '../../entity/contact.dart';
import '../../widgets/phone_text.dart';
import '../base_full_screen/entity_list_screen.dart';
import 'contact_edit_screen.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) => EntityListScreen<Contact>(
      pageTitle: 'Contacts',
      dao: DaoContact(),
      title: (entity) => Text('${entity.firstName} ${entity.surname}'),
      onEdit: (contact) => ContactEditScreen(contact: contact),
      details: (entity) {
        final customer = entity;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('''
Contact: ${customer.firstName} ${entity.surname}'''),
          PhoneText(label: 'Mobile:', phoneNo: customer.mobileNumber),
          if (Strings.isNotBlank(customer.emailAddress))
            Text('Email: ${customer.emailAddress}'),
        ]);
      });
}
