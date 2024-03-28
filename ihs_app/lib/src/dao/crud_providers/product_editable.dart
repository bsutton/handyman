import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../entities/organisation.dart';
import '../product_dao.dart';

/// The current product being edited by the crud
///
class OrganisationEditable with ChangeNotifier {
  String? _name;
  String? _organisationId;
  Uuid uuid = const Uuid();

  //Getters
  String? get name => _name;

  //Setters
  void changeName(String value) {
    _name = value;
    notifyListeners();
  }

  void loadValues(Organisation organisation) {
    _name = organisation.name;
    _organisationId = organisation.id;
  }

  Future<void> saveProduct() async {
    if (_organisationId == null) {
      final newProduct =
          Organisation(name: name, organisationId: uuid.v4());
      await OrganisationDao().saveProduct(newProduct);
    } else {
      //Update
      final updatedProduct =
          Organisation(name: name, price: _price, organisationId: _organisationId);
      await OrganisationDao().saveProduct(updatedProduct);
    }
  }
}
