// ignore_for_file: avoid_print, avoid_catches_without_on_clauses

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dao/crud_providers/product_editable.dart';
import '../dao/customer_dao.dart';
import '../dao/models/product.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({this.product, super.key});
  final Product? product;

  @override
  EditProductState createState() => EditProductState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Product?>('product', product));
  }
}

class EditProductState extends State<EditProduct> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.product == null) {
      //New Record
      nameController.text = '';
      priceController.text = '';
      Future.delayed(Duration.zero, () {
        Provider.of<ProductEditable>(context, listen: false)
            .loadValues(Product());
      });
    } else {
      //Controller Update
      nameController.text = widget.product!.name!;
      priceController.text = widget.product!.price.toString();
      //State Update
      Future.delayed(Duration.zero, () {
        Provider.of<ProductEditable>(context, listen: false)
            .loadValues(widget.product!);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductEditable>(context);
    final dao = ProductDao();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Product Name'),
              onChanged: productProvider.changeName,
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(hintText: 'Product Price'),
              onChanged: productProvider.changePrice,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                try {
                  await productProvider.saveProduct();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
            if (widget.product != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Set the button's background color
                    foregroundColor: Colors.white),
                child: const Text('Delete'),
                onPressed: () async {
                  await dao.removeProduct(widget.product!.productId!);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              )
            else
              Container(),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<TextEditingController>(
          'nameController', nameController))
      ..add(DiagnosticsProperty<TextEditingController>(
          'priceController', priceController));
  }
}
