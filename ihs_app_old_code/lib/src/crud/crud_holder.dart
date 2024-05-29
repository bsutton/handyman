import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../dao/entities/customer.dart';
import '../dao/entities/entity.dart';

import '../dao/dao.dart';

class CrudHolder<T> extends StatefulWidget {
  const CrudHolder(
      {required this.listWidget,
      required this.editable,
      required this.editorWidget,
      super.key});

  final CrudList listWidget;

  final CrudEditable<T> editable;

  final CrudEditor editorWidget;

  @override
  State<StatefulWidget> createState() => CrudHolderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CrudEditable<T>>('editable', editable));
  }
}

class CrudHolderState extends State<CrudHolder<Customer>> {
  @override
  Widget build(BuildContext context) => MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => widget.editable),
      ], builder: (context, child) => widget.editorWidget);
}

// ignore: avoid_implementing_value_types
abstract class CrudList implements Widget {}

// ignore: avoid_implementing_value_types
abstract class CrudEditor implements Widget {}

abstract class CrudEditable<T extends Entity<T>> extends ChangeNotifier {

  CrudEditable(this.dao)

  Dao<T> dao;
  // void init(T entity);

  // Future<void> save();

  late final T entity;
  // String? _name;
  // int? _customerId;
  Uuid uuid = const Uuid();

  //Getters
  // String? get name => _name;

  // //Setters
  // void changeName(String value) {
  //   _name = value;
  //   notifyListeners();
  // }

  /// initialise the CustomerEditable with the customer
  /// that we are going to be editing.
  void init(T entity) {
    this.entity = entity;
    // _name = customer.name;
    // _customerId = customer.id;
  }

  Future<void> save() async {
    if (entity.id == null) {
      final customer = Customer.forInsert();
      await CustomerDao().saveCustomer(customer);
    } else {
      //Update
      final updatedCustomer = Customer.withArgs(name!);
      await CustomerDao().saveCustomer(updatedCustomer);
    }
  }
}
