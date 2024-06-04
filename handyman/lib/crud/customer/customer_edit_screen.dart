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
  late bool _disbarred;
  late CustomerType _selectedCustomerType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name);
    _disbarred = widget.customer?.disbarred ?? false;
    _selectedCustomerType =
        widget.customer?.customerType ?? CustomerType.residential;
  }

  List<DropdownMenuItem<CustomerType>> _getCustomerTypeDropdownItems() =>
      CustomerType.values
          .map((type) => DropdownMenuItem<CustomerType>(
                value: type,
                child: Text(type.name),
              ))
          .toList();

  @override
  Widget build(BuildContext context) => EntityEditScreen<Customer>(
        entity: widget.customer,
        entityName: 'Customer',
        dao: DaoCustomer(),
        entityState: this,
        editor: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Customer Details',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          autofocus: true,
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Disbarred'),
                          value: _disbarred,
                          onChanged: (value) {
                            setState(() {
                              _disbarred = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<CustomerType>(
                          value: _selectedCustomerType,
                          decoration: const InputDecoration(
                            labelText: 'Customer Type',
                            border: OutlineInputBorder(),
                          ),
                          items: _getCustomerTypeDropdownItems(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCustomerType = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Contacts',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: ContactListScreen(
                              parent: Parent(widget.customer)),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sites',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child:
                              SiteListScreen(parent: Parent(widget.customer)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  @override
  Future<Customer> forUpdate(Customer customer) async => Customer.forUpdate(
      entity: customer,
      name: _nameController.text,
      disbarred: _disbarred,
      customerType: _selectedCustomerType);

  @override
  Future<Customer> forInsert() async => Customer.forInsert(
      name: _nameController.text,
      disbarred: _disbarred,
      customerType: _selectedCustomerType);
}
