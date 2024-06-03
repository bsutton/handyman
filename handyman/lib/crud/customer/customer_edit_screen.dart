// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_customer.dart';
import '../../entity/customer.dart';
import '../base_full_screen/entity_edit_screen.dart';
import '../base_nested/nested_list_screen.dart';
import '../contact/contact_list_screen.dart';
import '../site/site_list_screen.dart';

class CustomerEditScreen extends StatefulWidget {
  const CustomerEditScreen({super.key, this.customer});
  final Customer? customer;

  @override
  _CustomerEditScreenState createState() => _CustomerEditScreenState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Customer?>('customer', customer));
  }
}

class _CustomerEditScreenState extends State<CustomerEditScreen>
    implements EntityState<Customer> {
  late TextEditingController _nameController;
  late TextEditingController _disbarredController;
  late TextEditingController _customerTypeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name);
    _disbarredController =
        TextEditingController(text: widget.customer?.disbarred.toString());
    _customerTypeController =
        TextEditingController(text: widget.customer?.customerType.toString());
  }

  @override
  Widget build(BuildContext context) => EntityEditScreen<Customer>(
        entity: widget.customer,
        entityName: 'Customer',
        dao: DaoCustomer(),
        entityState: this,
        editor: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              autofocus: true,
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            SizedBox(
                height: 200,
                child: ContactListScreen(parent: Parent(widget.customer))),
            SizedBox(
                height: 200,
                child: SiteListScreen(parent: Parent(widget.customer))),
            TextFormField(
              controller: _disbarredController,
              decoration: const InputDecoration(labelText: 'Disbarred'),
            ),
            TextFormField(
              controller: _customerTypeController,
              decoration: const InputDecoration(labelText: 'Customer Type'),
            ),
          ],
        ),
      );

  @override
  Future<Customer> forUpdate(Customer customer) async => Customer.forUpdate(
      entity: customer,
      name: _nameController.text,
      disbarred: _disbarredController.text.toLowerCase() == 'true',
      customerType: CustomerType.residential);

  @override
  Future<Customer> forInsert() async => Customer.forInsert(
      name: _nameController.text,
      disbarred: _disbarredController.text.toLowerCase() == 'true',
      customerType: CustomerType.residential);
}
