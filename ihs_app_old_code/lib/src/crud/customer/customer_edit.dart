// ignore_for_file: avoid_print, avoid_catches_without_on_clauses

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dao/customer_dao.dart';
import '../../dao/entities/customer.dart';
import '../crud_holder.dart';

class EditCustomer extends StatefulWidget implements CrudEditor {
  const EditCustomer({this.customer, super.key});
  final Customer? customer;

  @override
  EditCustomerState createState() => EditCustomerState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Customer?>('customer', customer));
  }
}

class EditCustomerState extends State<EditCustomer> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.customer == null) {
      //New Record
      nameController.text = '';
      priceController.text = '';
      Future.delayed(Duration.zero, () {
        Provider.of<CrudEditable<Customer>>(context, listen: false)
            .init(Customer.forInsert());
      });
    } else {
      //Controller Update
      nameController.text = widget.customer!.name;
      //State Update
      Future.delayed(Duration.zero, () {
        Provider.of<CrudEditable<Customer>>(context, listen: false)
            .init(widget.customer!);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CrudEditable<Customer>>(context);
    final dao = CustomerDao();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Customer')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Customer Name'),
              onChanged: customerProvider.changeName,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                try {
                  await customerProvider.save();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
            if (widget.customer != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Set the button's background color
                    foregroundColor: Colors.white),
                child: const Text('Delete'),
                onPressed: () async {
                  await dao.removeCustomer(widget.customer!.id!);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              )
            else
              Container(),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<TextEditingController>(
          'nameController', nameController))
      ..add(DiagnosticsProperty<TextEditingController>(
          'priceController', priceController));
  }
}