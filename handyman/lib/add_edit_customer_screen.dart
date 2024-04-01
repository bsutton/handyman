// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strings/strings.dart';

import 'dao/dao_customer.dart';
import 'entity/customer.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final Customer? customer;

  const AddEditCustomerScreen({super.key, this.customer});

  @override
  _AddEditCustomerScreenState createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _siteLocationController;
  late TextEditingController _contactDetailsController;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _nameController = TextEditingController(text: widget.customer!.name);
      _siteLocationController =
          TextEditingController(text: widget.customer!.siteLocation);
      _contactDetailsController =
          TextEditingController(text: widget.customer!.contactDetails);
    } else {
      _nameController = TextEditingController();
      _siteLocationController = TextEditingController();
      _contactDetailsController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer != null ? 'Edit Customer' : 'Add Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: onEnterKey(
          onPressed: (context) => onSave(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  autofocus: true,
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
                  decoration:
                      const InputDecoration(labelText: 'Contact Details'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                    child: const Text('Save'), onPressed: () async => onSave())
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSave() async {
    if (_formKey.currentState!.validate()) {
      if (widget.customer != null) {
        // Editing existing customer
        Customer customer = Customer(
          id: widget.customer!.id,
          name: _nameController.text,
          siteLocation: _siteLocationController.text,
          contactDetails: _contactDetailsController.text,
        );

        await DaoCustomer().update(customer);
      } else {
        // Adding new customer
        Customer customer = Customer.forInsert(
          name: _nameController.text,
          siteLocation: _siteLocationController.text,
          contactDetails: _contactDetailsController.text,
        );

        await DaoCustomer().insert(customer);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Widget onEnterKey(
      {required Widget child,
      required Function(BuildContext context) onPressed}) {
    return KeyboardListener(
        focusNode:
            FocusNode(), // Ensure that the RawKeyboardListener receives key events
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            // Handle Enter key press here
            // For example, call onPressed for the RaisedButton
            onPressed(context);
          }
        },
        child: child);
  }
}
