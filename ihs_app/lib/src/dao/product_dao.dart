// ignore_for_file: avoid_catches_without_on_clauses, avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'models/product.dart';

class ProductDao with ChangeNotifier {
  factory ProductDao() {
    _self ??= ProductDao._();

    return _self!;
  }

  ProductDao._() : _db = FirebaseFirestore.instance;
  static ProductDao? _self;

  final FirebaseFirestore _db;

  Stream<List<Product>> getProducts() =>
      _db.collection('products').snapshots().map((snapshot) => snapshot.docs
          .map((document) => Product.fromFirestore(document.data()))
          .toList());

  /// create or update a product.
  Future<void> saveProduct(Product product) async {
    final completer = Completer<void>();
    try {
      await _db
          .collection('products')
          .doc(product.productId)
          .set(product.toMap())
          .then((value) {
        print('Product saved: $product');
        completer.complete();
      }, onError: (e) {
        completer.complete();
        print('Error updating appointment: $e');
      });
    } catch (e) {
      print(e);
    }

    await completer.future;
    print('finished saving');
  }

  Future<void> removeProduct(String productId) async =>
      _db.collection('products').doc(productId).delete();
}
