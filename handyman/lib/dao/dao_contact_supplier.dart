import 'package:sqflite/sqflite.dart';

import '../entity/contact.dart';
import '../entity/supplier.dart';
import 'dao.dart';

class DaoContactSupplier extends Dao<Contact> {
  Future<void> createTable(Database db, int version) async {}

  @override
  Contact fromMap(Map<String, dynamic> map) => Contact.fromMap(map);

  @override
  String get tableName => 'supplier_contact';

  Future<void> deleteJoin(Supplier supplier, Contact contact,
      [Transaction? transaction]) async {
    await getDb(transaction).delete(
      tableName,
      where: 'supplier_id = ? and contact_id = ?',
      whereArgs: [supplier.id, contact.id],
    );
  }

  Future<void> insertJoin(Contact contact, Supplier supplier,
      [Transaction? transaction]) async {
    await getDb(transaction).insert(
      tableName,
      {'supplier_id': supplier.id, 'contact_id': contact.id},
    );
  }
}
