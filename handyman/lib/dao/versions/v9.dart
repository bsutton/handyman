import 'package:sqflite/sqflite.dart';

import '../database_extension.dart';

Future<void> applyV9(Database db) async {
  await db.x('''
      CREATE TABLE system(
        id INTEGER,
        fromEmail TEXT,
        BSB TEXT,
        accountNo TEXT,
        addressLine1 TEXT,
        addressLine2 TEXT,
        suburb TEXT,
        state TEXT,
        postcode TEXT,
        mobileNumber TEXT,
        landLine TEXT,
        officeNumber TEXT,
        emailAddress TEXT,
        webUrl TEXT,
        createdDate TEXT,
        modifiedDate TEXT
      )
    ''');

  await db.x('''
insert into system (id, fromEmail)
values 
(1, 'testemail@replacemenow.bad.email')
''');
}
