import 'package:flutter/material.dart';

import '../../dao/dao_supplier.dart';
import '../../entity/entities.dart';
import '../base/entity_list_screen.dart';
import 'supplier_edit_screen.dart';

class SupplierListScreen extends StatelessWidget {
  const SupplierListScreen({super.key});

  @override
  Widget build(BuildContext context) => EntityListScreen<Supplier>(
      pageTitle: 'Suppliers',
      dao: DaoSupplier(),
      title: (entity) => Text(entity.name) as Widget,
      onEdit: (supplier) => SupplierEditScreen(suppler: supplier),
      subTitle: (entity) {
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
