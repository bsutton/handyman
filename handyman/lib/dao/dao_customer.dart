import 'package:handyman/dao/dao.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/customer.dart';

class DaoCustomer {
  void createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        primaryFirstName TEXT,
        primarySurname TEXT,
        primaryAddressLine1 TEXT,
        primaryAddressLine2 TEXT,
        primarySuburb TEXT,
        primaryState TEXT,
        primaryPostcode TEXT,
        primaryMobileNumber TEXT,
        primaryLandLine TEXT,
        primaryOfficeNumber TEXT,
        primaryEmailAddress TEXT,
        secondaryFirstName TEXT,
        secondarySurname TEXT,
        secondaryAddressLine1 TEXT,
        secondaryAddressLine2 TEXT,
        secondarySuburb TEXT,
        secondaryState TEXT,
        secondaryPostcode TEXT,
        secondaryMobileNumber TEXT,
        secondaryLandLine TEXT,
        secondaryOfficeNumber TEXT,
        secondaryEmailAddress TEXT,
        createdDate TEXT,
        modifiedDate TEXT,
        disbarred INTEGER,
        customerType INTEGER
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
