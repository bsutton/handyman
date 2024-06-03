import 'package:sqflite/sqflite.dart';

import '../database_extension.dart';

Future<void> applyV12(Database db) async {
  await db.x('''
drop table contact
    ''');
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

  // await db.x('''
  // insert into customer_contact (customer_id, contact_id)
  // select customer_id, id from contact''');

  // await db.x('''
  //    alter table contact drop column customer_id;
  //     )
  //   ''');
}
