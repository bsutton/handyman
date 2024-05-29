// ignore_for_file: avoid_catches_without_on_clauses, avoid_print

import 'dart:async';

import 'package:firedart/firestore/firestore.dart';
import 'package:flutter/foundation.dart';

import 'entities/customer.dart';

class CustomerDao with ChangeNotifier {
  factory CustomerDao() {
    _self ??= CustomerDao._();

    return _self!;
  }

  CustomerDao._() : _db = Firestore.instance;
  static CustomerDao? _self;

  final Firestore _db;

  Stream<List<Customer>> getCustomers() =>
      _db.collection('Customers').stream.map((documents) => documents
          .map((document) => Customer.fromJson(document.map))
          .toList());

  /// create or update a Customer.
  Future<void> saveCustomer(Customer customer) async {
    final completer = Completer<void>();
    try {
      await _db
          .collection('Customers')
          .document('${customer.id}')
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
      _db.collection('Customers').document('$customerId').delete();
}
