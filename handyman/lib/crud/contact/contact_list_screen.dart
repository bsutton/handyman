import 'package:flutter/material.dart';
import 'package:strings/strings.dart';

import '../../dao/dao_contact.dart';
import '../../entity/contact.dart';
import '../../entity/customer.dart';
import '../../widgets/phone_text.dart';
import '../base_nested/nested_list_screen.dart';
import 'contact_edit_screen.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({required this.parent, super.key});

  final Parent<Customer> parent;

  @override
  Widget build(BuildContext context) =>
      NestedEntityListScreen<Contact, Customer>(
          parent: parent,
          pageTitle: 'Contacts',
          dao: DaoContact(),
          // ignore: discarded_futures
          fetchList: () => DaoContact().getByCustomer(parent.parent),
          title: (entity) => Text('${entity.firstName} ${entity.surname}'),
          onEdit: (contact) =>
              ContactEditScreen(customer: parent.parent!, contact: contact),
          details: (entity) {
            final customer = entity;
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PhoneText(label: 'Mobile:', phoneNo: customer.mobileNumber),
                  if (Strings.isNotBlank(customer.emailAddress))
                    Text('Email: ${customer.emailAddress}'),
                ]);
          });
}
