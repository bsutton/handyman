// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'crud/add_edit_customer_screen.dart';
import 'dao/dao_customer.dart';
import 'entity/entities.dart';

class OldCustomerListScreen extends StatefulWidget {
  const OldCustomerListScreen({super.key});

  @override
  _OldCustomerListScreenState createState() => _OldCustomerListScreenState();
}

class _OldCustomerListScreenState extends State<OldCustomerListScreen> {
  Future<List<Customer>>? _customers;

  @override
  void initState() {
    super.initState();
    _refreshCustomerList();
  }

  Future<void> _refreshCustomerList() async {
    setState(() {
      _customers = DaoCustomer().getAll();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Customer List'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (context) => const AddEditCustomerScreen()),
                ).then((_) =>
                    _refreshCustomerList()); // Refresh list after adding/editing
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: _customers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData ||
                (snapshot.hasData && snapshot.data!.isEmpty)) {
              return const Center(
                child: Text('No customers found.'),
              );
            } else {
              final customerList = snapshot.data!;
              return ListView.builder(
                itemCount: customerList.length,
                itemBuilder: (context, index) {
                  final customer = customerList[index];
                  return ListTile(
                    title: Text(customer.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Business Name: ${customer.name}'),
                        Text('''
Primary Contact: ${customer.primaryFirstName} ${customer.primarySurname}'''),
                        Text('Mobile: ${customer.primaryMobileNumber}'),
                        Text('Email: ${customer.primaryEmailAddress}'),
                        Text(
                            '''Address: ${customer.primaryAddressLine1}, ${customer.primaryAddressLine2}, ${customer.primarySuburb}, ${customer.primaryState}, ${customer.primaryPostcode}'''),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await _deleteCustomer(customer);
                      },
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (context) =>
                                AddEditCustomerScreen(customer: customer)),
                      ).then((_) =>
                          _refreshCustomerList()); // Refresh list after editing
                    },
                  );
                },
              );
            }
          },
        ),
      );

  Future<void> _deleteCustomer(Customer customer) async {
    await DaoCustomer().delete(customer.id);
    await _refreshCustomerList();
  }
}
