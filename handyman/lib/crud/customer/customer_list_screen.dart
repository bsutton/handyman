import 'package:flutter/material.dart';

import '../../dao/dao.dart';
import '../../entity/customer.dart';
import '../base/entity_list_screen.dart';
import 'customer_edit_screen.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) => EntityListScreen<Customer>(
      pageTitle: 'Customers',
      dao: DaoCustomer(),
      title: (entity) => Text(entity.name) as Widget,
      onEdit: (customer) => CustomerEditScreen(customer: customer),
      details: (entity) {
        final customer = entity;
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
