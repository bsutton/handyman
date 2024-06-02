import 'package:sqflite/sqflite.dart';

import '../database_extension.dart';

Future<void> applyV8(Database db) async {
  await db.x('''
drop table contact
    ''');
  await db.x('''
      CREATE TABLE contact(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id int,
        firstName TEXT,
        surname TEXT,
        addressLine1 TEXT,
        addressLine2 TEXT,
        suburb TEXT,
        state TEXT,
        postcode TEXT,
        mobileNumber TEXT,
        landLine TEXT,
        officeNumber TEXT,
        emailAddress TEXT,
        createdDate TEXT,
        modifiedDate TEXT,
        FOREIGN KEY (customer_id)  REFERENCES customer(id)   
      )
    ''');
}
