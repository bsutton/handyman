// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_customer.dart';
import '../../dao/join_adaptors/customer_contact_join_adaptor.dart';
import '../../dao/join_adaptors/customer_site_join_adaptor.dart';
import '../../entity/customer.dart';
import '../../widgets/hbm_crud_contact.dart';
import '../../widgets/hmb_crud_site.dart';
import '../../widgets/hmb_droplist.dart';
import '../../widgets/hmb_form_section.dart';
import '../../widgets/hmb_switch.dart';
import '../../widgets/hmb_text_field.dart';
import '../base_full_screen/entity_edit_screen.dart';
import '../base_nested/nested_list_screen.dart';

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
                HMBFormSection(
                  children: [
                    Text(
                      'Customer Details',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    HMBTextField(
                      autofocus: true,
                      controller: _nameController,
                      labelText: 'Name',
                      required: true,
                    ),
                    HMBSwitch(
                        labelText: 'Disbarred',
                        initialValue: _disbarred,
                        onChanged: (value) {
                          setState(() {
                            _disbarred = value;
                          });
                        }),
                    HMBDroplist<CustomerType>(
                        initialValue: _selectedCustomerType,
                        items: CustomerType.values,
                        labelText: 'Customer Type',
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCustomerType = newValue!;
                          });
                        }),
                  ],
                ),
                HMBCrudContact(
                  parent: Parent(widget.customer),
                  daoJoin: CustomerContactJoinAdaptor(),
                ),
                HBMCrudSite(
                    daoJoin: CustomerSiteJoinAdaptor(),
                    parent: Parent(widget.customer)),
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
