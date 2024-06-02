import 'package:sqflite/sqflite.dart';

import '../database_extension.dart';

Future<void> applyV1(Database db) async {
  await db.x('''
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
