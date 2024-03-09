import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dao/crud_providers/product_editable.dart';
import '../dao/models/product.dart';

class CrudHolder<Model> extends StatefulWidget {
  const CrudHolder({required this.child, required this.editable, super.key});

  final Widget child;

  final ProductEditable editable;

  @override
  State<StatefulWidget> createState() => CrudHolderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProductEditable>('editable', editable));
  }
}

class CrudHolderState extends State<CrudHolder<Product>> {
  @override
  Widget build(BuildContext context) => MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => ProductEditable()),
      ], child: widget.child);
}
