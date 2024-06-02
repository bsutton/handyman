import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:june/june.dart';

import '../dao/dao_customer.dart';
import '../entity/customer.dart';

class SelectCustomer extends StatefulWidget {
  const SelectCustomer({required this.selectedCustomer, super.key});
  final SelectedCustomer selectedCustomer;

  @override
  SelectCustomerState createState() => SelectCustomerState();
}

class SelectCustomerState extends State<SelectCustomer> {
  @override
  Widget build(BuildContext context) => FutureBuilderEx(
        // ignore: discarded_futures
        future: DaoCustomer().getById(widget.selectedCustomer.customerId),
        builder: (context, selectedCustomer) => FutureBuilderEx<List<Customer>>(
            // ignore: discarded_futures
            future: DaoCustomer().getAll(),
            builder: (context, data) => DropdownButtonFormField<Customer>(
                  value: selectedCustomer,
                  hint: const Text('Select a customer'),
                  onChanged: (newValue) {
                    setState(() {
                      widget.selectedCustomer.customerId = newValue?.id;
                    });
                  },
                  items: data!
                      .map((customer) => DropdownMenuItem<Customer>(
                            value: customer,
                            child: Text(customer.name),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Customer'),
                  validator: (value) =>
                      value == null ? 'Please select a Customer' : null,
                )),
      );
}

class SelectedCustomer extends JuneState {
  SelectedCustomer();

  int? customerId;
}
