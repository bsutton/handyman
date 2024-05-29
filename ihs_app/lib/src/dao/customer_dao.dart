// ignore_for_file: avoid_catches_without_on_clauses, avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'entities/customer.dart';

class CustomerDao with ChangeNotifier {
  factory CustomerDao() {
    _self ??= CustomerDao._();

    return _self!;
  }

  CustomerDao._() : _db = FirebaseFirestore.instance;
  static CustomerDao? _self;

  final FirebaseFirestore _db;

  Stream<List<Customer>> getCustomers() =>
      _db.collection('Customers').snapshots().map((snapshot) => snapshot.docs
          .map((document) => Customer.fromJson(document.data()))
          .toList());

  /// create or update a Customer.
  Future<void> saveCustomer(Customer customer) async {
    final completer = Completer<void>();
    try {
      await _db
          .collection('Customers')
          .doc('${customer.id}')
          .set(customer.toJson())
          .then((value) {
        print('Customer saved: $Customer');
        completer.complete();
        // ignore: avoid_types_on_closure_parameters
      }, onError: (Object e) {
        completer.complete();
        print('Error updating appointment: $e');
      });
    } catch (e) {
      print(e);
    }

    await completer.future;
    print('finished saving');
  }

  Future<void> removeCustomer(int customerId) async =>
      _db.collection('Customers').doc('$customerId').delete();
}
