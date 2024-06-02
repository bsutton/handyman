// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_site.dart';
import '../../entity/site.dart';
import '../base_full_screen/entity_edit_screen.dart';

class SiteEditScreen extends StatefulWidget {
  const SiteEditScreen({super.key, this.site});
  final Site? site;

  @override
  _SiteEditScreenState createState() => _SiteEditScreenState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Site?>('Site', site));
  }
}

class _SiteEditScreenState extends State<SiteEditScreen>
    implements EntityState<Site> {
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _suburbController;
  late TextEditingController _stateController;
  late TextEditingController _sostcodeController;

  @override
  void initState() {
    super.initState();
    _addressLine1Controller =
        TextEditingController(text: widget.site?.addressLine1);
    _addressLine2Controller =
        TextEditingController(text: widget.site?.addressLine2);
    _suburbController = TextEditingController(text: widget.site?.suburb);
    _stateController = TextEditingController(text: widget.site?.state);
    _sostcodeController = TextEditingController(text: widget.site?.postcode);
  }

  @override
  Widget build(BuildContext context) => EntityEditScreen<Site>(
        entity: widget.site,
        entityName: 'Site',
        dao: DaoSite(),
        entityState: this,
        editor: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add other form fields for the new fields
            TextFormField(
              controller: _addressLine1Controller,
              decoration: const InputDecoration(labelText: ' Address Line 1'),
            ),
            TextFormField(
              controller: _addressLine2Controller,
              decoration: const InputDecoration(labelText: ' Address Line 2'),
            ),
            TextFormField(
              controller: _suburbController,
              decoration: const InputDecoration(labelText: ' Suburb'),
            ),
            TextFormField(
              controller: _stateController,
              decoration: const InputDecoration(labelText: ' State'),
            ),
            TextFormField(
              controller: _sostcodeController,
              decoration: const InputDecoration(labelText: ' Postcode'),
            ),
          ],
        ),
      );

  @override
  Future<Site> forUpdate(Site site) async => Site.forUpdate(
      entity: site,
      addressLine1: _addressLine1Controller.text,
      addressLine2: _addressLine2Controller.text,
      suburb: _suburbController.text,
      state: _stateController.text,
      postcode: _sostcodeController.text);

  @override
  Future<Site> forInsert() async => Site.forInsert(
        addressLine1: _addressLine1Controller.text,
        addressLine2: _addressLine2Controller.text,
        suburb: _suburbController.text,
        state: _stateController.text,
        postcode: _sostcodeController.text,
      );
}
