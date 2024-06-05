import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:june/june.dart';

import '../crud/customer/customer_edit_screen.dart';
import '../dao/dao_customer.dart';
import '../entity/customer.dart';
import 'hmb_add_button.dart';

class SelectCustomer extends StatefulWidget {
  const SelectCustomer(
      {required this.selectedCustomer, super.key, this.onSelected});
  final SelectedCustomer selectedCustomer;

  final void Function(Customer? customer)? onSelected;

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
          builder: (context, data) => Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<Customer>(
                  value: selectedCustomer,
                  hint: const Text('Select a customer'),
                  onChanged: (newValue) {
                    setState(() {
                      widget.selectedCustomer.customerId = newValue?.id;
                    });
                    widget.onSelected?.call(newValue);
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
                ),
              ),
              HMBAddButton(
                  enabled: true,
                  onPressed: () async {
                    final customer = await Navigator.push<Customer>(
                      context,
                      MaterialPageRoute<Customer>(
                          builder: (context) => const CustomerEditScreen()),
                    );
                    setState(() {
                      widget.selectedCustomer.customerId = customer?.id;
                    });
                  }),
            ],
          ),
        ),
      );
}

class SelectedCustomer extends JuneState {
  SelectedCustomer();

  int? customerId;
}
