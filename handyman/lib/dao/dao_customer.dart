import 'package:handyman/dao/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/customer.dart';

class DaoCustomer {
  void createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        siteLocation TEXT,
        contactDetails TEXT
      )
    ''');
  }

  Future<int> insert(Customer customer, [Transaction? transaction]) async {
    final db = _db(transaction);
    final id = await db.insert('customers', customer.toMap()..remove('id'));
    customer.id = id;
    return id;
  }

  DatabaseExecutor _db([Transaction? transaction]) {
    return (transaction ?? DatabaseHelper.instance.database);
  }

  Future<List<Customer>> getAll([Transaction? transaction]) async {
    final db = _db(transaction);
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return List.generate(maps.length, (i) {
      return Customer.fromMap(maps[i]);
    });
  }

  Future<int> update(Customer customer, [Transaction? transaction]) async {
    final db = _db(transaction);
    return await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> delete(int id, [Transaction? transaction]) async {
    final db = _db(transaction);
    return await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
