import 'package:sqflite/sqflite.dart';

final Map<int, Future<void> Function(Database)?> upgrades = {
  1: _applyV1,
  2: _applyV2
};

Future<void> upgradeDb(Database db, int oldVersion, int newVersion) async {
  if (oldVersion == 1) {
    print('Creating database');
  } else {
    print('Upgrade database');
  }
  for (var version = oldVersion; version <= newVersion; version++) {
    print('Upgrading to $version');
    await upgrades[version]?.call(db);
  }
}

Future<void> _applyV2(Database db) async {
  await db.execute('''
      CREATE TABLE jobs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        createdDate TEXT,
        modifiedDate TEXT,
        customerId INTEGER,
        startDate TEXT,
        summary TEXT,
        description TEXT,
        address TEXT
      )
    ''');

  await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        jobId INTEGER,
        name TEXT,
        description TEXT,
        completed INTEGER,
        FOREIGN KEY (jobId) REFERENCES jobs(id)
      )
    ''');
}

Future<void> _applyV1(Database db) async {
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
