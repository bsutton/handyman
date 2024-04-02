import 'package:flutter/material.dart';

import '../dao/dao.dart';
import '../entity/entities.dart';
import 'add_edit_customer_screen.dart';
import 'base/entity_list_screen.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

  @override
  Widget build(BuildContext context) => EntityListScreen<Entity>(
      dao: DaoCustomer(),
      title: (entity) => const Text('Customer List') as Widget,
      onEdit: (customer) =>
          AddEditCustomerScreen(customer: customer as Customer?),
      subTitle: (entity) {
        final customer = entity as Customer;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Business Name: ${customer.name}'),
          Text('''
      Primary Contact: ${customer.primaryFirstName} ${entity.primarySurname}'''),
          Text('Mobile: ${customer.primaryMobileNumber}'),
          Text('Email: ${customer.primaryEmailAddress}'),
          Text('''
      Address: ${customer.primaryAddressLine1}, ${customer.primaryAddressLine2}, ${customer.primarySuburb}, ${customer.primaryState}, ${customer.primaryPostcode}''')
        ]);
      });
}
