// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:handyman/entity/customer.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailScreen(this.customer, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Name: ${customer.name}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Site Location: ${customer.siteLocation}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Contact Details: ${customer.contactDetails}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
