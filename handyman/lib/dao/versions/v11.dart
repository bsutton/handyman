import 'package:sqflite/sqflite.dart';

import '../database_extension.dart';

Future<void> applyV11(Database db) async {

  await db.x('''
      CREATE TABLE customer_contact(
        contact_id integer,
        customer_id integer,
        createdDate TEXT,
        modifiedDate TEXT,
        FOREIGN KEY (contact_id) references contact(id),
        FOREIGN KEY (customer_id) references customer(id)
      )
    ''');
  await db.x(
      '''CREATE UNIQUE INDEX customer_contacts_unq ON customer_contact(contact_id, customer_id);''');

  await db.x('''
      CREATE TABLE supplier_contact(
        contact_id integer,
        supplier_id, integer,
        createdDate TEXT,
        modifiedDate TEXT,
        FOREIGN KEY (contact_id) references contact(id),
        FOREIGN KEY (supplier_id) references supplier(id)
      )
    ''');

  await db.x(
      '''CREATE UNIQUE INDEX supplier_contacts_unq ON supplier_contact(contact_id, supplier_id);''');

  await db.x('''
      CREATE TABLE job_contact(
        contact_id integer,
        job_id integer,
        createdDate TEXT,
        modifiedDate TEXT,
        FOREIGN KEY (contact_id) references contact(id),
        FOREIGN KEY (job_id) references job(id)
      )
    ''');

  await db
      .x('''CREATE UNIQUE INDEX job_contacts_unq ON job_contact(contact_id, contact_id);''');


}
