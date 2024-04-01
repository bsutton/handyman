// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:strings/strings.dart';

import 'dao/dao_customer.dart';
import 'entity/customer.dart';

class AddEditCustomerScreen extends StatefulWidget {
  const AddEditCustomerScreen({super.key});

  @override
  _AddEditCustomerScreenState createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _siteLocationController = TextEditingController();
  final TextEditingController _contactDetailsController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (Strings.isEmpty(value)) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _siteLocationController,
                decoration: const InputDecoration(labelText: 'Site Location'),
              ),
              TextFormField(
                controller: _contactDetailsController,
                decoration: const InputDecoration(labelText: 'Contact Details'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Customer customer = Customer.forInsert(
                      name: _nameController.text,
                      siteLocation: _siteLocationController.text,
                      contactDetails: _contactDetailsController.text,
                    );
                    await DaoCustomer().insert(customer);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
