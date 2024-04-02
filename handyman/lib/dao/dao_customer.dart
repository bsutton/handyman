import 'package:sqflite/sqflite.dart';

import '../entity/customer.dart';
import 'dao.dart';

class DaoCustomer extends Dao {
  Future<void> createTable(Database db, int version) async {
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

  @override
  Future<int> insert(covariant Customer entity,
      [Transaction? transaction]) async {
    final db = _db(transaction);
    final id = await db.insert('customers', entity.toMap()..remove('id'));
    entity.id = id;
    return id;
  }

  DatabaseExecutor _db([Transaction? transaction]) =>
      transaction ?? DatabaseHelper.instance.database;

  @override
  Future<List<Customer>> getAll([Transaction? transaction]) async {
    final db = _db(transaction);
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return List.generate(maps.length, (i) => Customer.fromMap(maps[i]));
  }

  @override
  Future<int> update(covariant Customer entity,
      [Transaction? transaction]) async {
    final db = _db(transaction);
    return db.update(
      'customers',
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }

  @override
  Future<int> delete(int id, [Transaction? transaction]) async {
    final db = _db(transaction);
    return db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
