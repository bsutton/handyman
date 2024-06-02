import 'package:sqflite/sqflite.dart';

import '../database_extension.dart';

Future<void> applyV7(Database db) async {
  await db.x('''
      CREATE TABLE contact(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
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
        modifiedDate TEXT
      )
    ''');
}
