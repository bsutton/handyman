import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/product.dart';
import '../product_dao.dart';

/// The current product being edited by the crud
///
class ProductEditable with ChangeNotifier {
  String? _name;
  double? _price;
  String? _productId;
  Uuid uuid = const Uuid();

  //Getters
  String? get name => _name;
  double? get price => _price;

  //Setters
  void changeName(String value) {
    _name = value;
    notifyListeners();
  }

  // ignore: avoid_setters_without_getters
  void changePrice(String value) {
    _price = double.parse(value);
    notifyListeners();
  }

  void loadValues(Product product) {
    _name = product.name;
    _price = product.price;
    _productId = product.productId;
  }

  Future<void> saveProduct() async {
    if (_productId == null) {
      final newProduct =
          Product(name: name, price: price, productId: uuid.v4());
      await ProductDao().saveProduct(newProduct);
    } else {
      //Update
      final updatedProduct =
          Product(name: name, price: _price, productId: _productId);
      await ProductDao().saveProduct(updatedProduct);
    }
  }
}
