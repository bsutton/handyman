import 'package:sqflite/sqflite.dart';

import '../entity/contact.dart';
import '../entity/customer.dart';
import '../entity/site.dart';
import 'dao.dart';

class DaoContactCustomer extends Dao<Site> {
  Future<void> createTable(Database db, int version) async {}

  @override
  Site fromMap(Map<String, dynamic> map) => Site.fromMap(map);

  @override
  String get tableName => 'customer_contact';

  Future<void> deleteJoin(Customer customer, Contact contact,
      [Transaction? transaction]) async {
    await getDb(transaction).delete(
      tableName,
      where: 'customer_id = ? and contact_id = ?',
      whereArgs: [customer.id, contact.id],
    );
  }

  Future<void> insertJoin(Contact contact, Customer customer,
      [Transaction? transaction]) async {
    await getDb(transaction).insert(
      tableName,
      {'customer_id': customer.id, 'contact_id': contact.id},
    );
  }
}
