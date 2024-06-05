// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_supplier.dart';
import '../../dao/join_adaptors/supplier_contact_join_adaptor.dart';
import '../../dao/join_adaptors/supplier_site_join_adaptor.dart';
import '../../entity/supplier.dart';
import '../../widgets/hmb_child_crud_card.dart';
import '../../widgets/hmb_form_section.dart';
import '../../widgets/hmb_text_field.dart';
import '../base_full_screen/entity_edit_screen.dart';
import '../base_nested/nested_list_screen.dart';
import '../contact/contact_list_screen.dart';
import '../site/site_list_screen.dart';

class SupplierEditScreen extends StatefulWidget {
  const SupplierEditScreen({super.key, this.supplier});
  final Supplier? supplier;

  @override
  _SupplierEditScreenState createState() => _SupplierEditScreenState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Supplier?>('supplier', supplier));
  }
}

class _SupplierEditScreenState extends State<SupplierEditScreen>
    implements EntityState<Supplier> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supplier?.name);
  }

  @override
  Widget build(BuildContext context) => EntityEditScreen<Supplier>(
        entity: widget.supplier,
        entityName: 'Supplier',
        dao: DaoSupplier(),
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
                      'Supplier Details',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    HMBTextField(
                      autofocus: true,
                      controller: _nameController,
                      labelText: 'Name',
                      required: true,
                    ),
                  ],
                ),
                HMBChildCrudCard(
                    headline: 'Contacts',
                    crudListScreen: ContactListScreen(
                        pageTitle: 'Contacts',
                        parent: Parent(widget.supplier),
                        daoJoin: SupplierContactJoinAdaptor())),
                HMBChildCrudCard(
                    headline: 'Sites',
                    crudListScreen: SiteListScreen(
                        daoJoin: SupplierSiteJoinAdaptor(),
                        parent: Parent(widget.supplier))),
              ],
            ),
          ],
        ),
      );

  @override
  Future<Supplier> forUpdate(Supplier supplier) async => Supplier.forUpdate(
        entity: supplier,
        name: _nameController.text,
      );

  @override
  Future<Supplier> forInsert() async => Supplier.forInsert(
        name: _nameController.text,
      );
}
