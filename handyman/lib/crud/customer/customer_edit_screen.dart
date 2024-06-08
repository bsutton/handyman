// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_customer.dart';
import '../../dao/join_adaptors/join_adaptor_customer_contact.dart';
import '../../dao/join_adaptors/join_adaptor_customer_site.dart';
import '../../entity/customer.dart';
import '../../util/money_ex.dart';
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
  late TextEditingController _hourlyRateController;
  late bool _disbarred;
  late CustomerType _selectedCustomerType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name);
    _hourlyRateController = TextEditingController(
        text: widget.customer?.hourlyRate.amount.toString() ?? '0');
    _disbarred = widget.customer?.disbarred ?? false;
    _selectedCustomerType =
        widget.customer?.customerType ?? CustomerType.residential;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
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
                    HMBTextField(
                      controller: _hourlyRateController,
                      labelText: 'Hourly Rate',
                      keyboardType: TextInputType.number,
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
                      initialItem: () async => _selectedCustomerType,
                      items: (filter) async => CustomerType.values,
                      title: 'Customer Type',
                      onChanged: (newValue) {
                        _selectedCustomerType = newValue;
                      },
                      format: (item) => item.name,
                    ),
                  ],
                ),
                HMBCrudContact(
                  parent: Parent(widget.customer),
                  daoJoin: JoinAdaptorCustomerContact(),
                ),
                HBMCrudSite(
                    daoJoin: JoinAdaptorCustomerSite(),
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
      customerType: _selectedCustomerType,
      hourlyRate: MoneyEx.tryParse(_hourlyRateController.text));

  @override
  Future<Customer> forInsert() async => Customer.forInsert(
      name: _nameController.text,
      disbarred: _disbarred,
      customerType: _selectedCustomerType,
      hourlyRate: MoneyEx.tryParse(_hourlyRateController.text));
}
