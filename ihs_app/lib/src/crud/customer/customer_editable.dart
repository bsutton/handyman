import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../dao/customer_dao.dart';
import '../../dao/entities/customer.dart';

/// The current customer being edited by the crud
///
class CustomerEditable with ChangeNotifier {
  String? _name;
  int? _customerId;
  Uuid uuid = const Uuid();

  //Getters
  String? get name => _name;

  //Setters
  void changeName(String value) {
    _name = value;
    notifyListeners();
  }

  void loadValues(Customer customer) {
    _name = customer.name;
    _customerId = customer.id;
  }

  Future<void> save() async {
    if (_customerId == null) {
      final customer = Customer.forInsert();
      await CustomerDao().saveCustomer(customer);
    } else {
      //Update
      final updatedProduct = Customer.withArgs(name!);
      await CustomerDao().saveCustomer(updatedProduct);
    }
  }
}
