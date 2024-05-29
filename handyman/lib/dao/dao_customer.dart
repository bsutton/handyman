import 'package:sqflite/sqflite.dart';

import '../entity/customer.dart';
import 'dao.dart';

class DaoCustomer extends Dao<Customer> {
  Future<void> createTable(Database db, int version) async {}

  @override
  Customer fromMap(Map<String, dynamic> map) => Customer.fromMap(map);

  @override
  String get tableName => 'customers';
}
