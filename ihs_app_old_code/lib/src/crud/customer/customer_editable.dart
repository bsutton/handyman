import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../dao/customer_dao.dart';
import '../../dao/entities/customer.dart';
import '../crud_holder.dart';

/// The current customer being edited by the crud
///
class CustomerEditable with ChangeNotifier implements CrudEditable<Customer> {
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

/// initialise the CustomerEditable with the customer
/// that we are going to be editing.
  @override

  void init(covariant Customer customer) {
    _name = customer.name;
    _customerId = customer.id;
  }

  @override
  Future<void> save() async {
    if (_customerId == null) {
      final customer = Customer.forInsert();
      await CustomerDao().saveCustomer(customer);
    } else {
      //Update
      final updatedCustomer = Customer.withArgs(name!);
      await CustomerDao().saveCustomer(updatedCustomer);
    }
  }
}
