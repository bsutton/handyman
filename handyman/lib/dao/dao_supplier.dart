import 'package:sqflite/sqflite.dart';

import '../entity/supplier.dart';
import 'dao.dart';

class DaoSupplier extends Dao<Supplier> {
  Future<void> createTable(Database db, int version) async {}

  @override
  Supplier fromMap(Map<String, dynamic> map) => Supplier.fromMap(map);

  @override
  String get tableName => 'suppliers';
}
