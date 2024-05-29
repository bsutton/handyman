import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dao/entities/customer.dart';
import 'customer/customer_editable.dart';

class CrudHolder<Model> extends StatefulWidget {
  const CrudHolder(
      {required this.listWidget, required this.editable, super.key});

  final CrudList listWidget;

  final CustomerEditable editable;

  @override
  State<StatefulWidget> createState() => CrudHolderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CustomerEditable>('editable', editable));
  }
}

class CrudHolderState extends State<CrudHolder<Customer>> {
  @override
  Widget build(BuildContext context) => MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => CustomerEditable()),
      ], child: widget.listWidget);
}

// ignore: avoid_implementing_value_types
abstract class CrudList implements Widget {}
