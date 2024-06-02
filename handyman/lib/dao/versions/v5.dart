import 'package:sqflite/sqflite.dart';

import '../database_extension.dart';

Future<void> applyV5(Database db) async {
  await db.x('''create UNIQUE INDEX customer_name on customer(name)''');
  await db.x('''create UNIQUE INDEX supplier_name on supplier(name)''');

  /// find a job by the customer.
  await db.x('''create INDEX job_customer on job(customer_id)''');

  await db.x('''
      CREATE TABLE site(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        addressLine1 TEXT,
        addressLine2 TEXT,
        suburb TEXT,
        state TEXT,
        postcode TEXT,
        mobileNumber TEXT,
        landLine TEXT,
        officeNumber TEXT,
        emailAddress TEXT,
        alternateEmailAddress TEXT,
        createdDate TEXT,
        modifiedDate TEXT
      )
    ''');

  await db.x('''
      CREATE TABLE customer_site(
        site_id integer,
        customer_id integer,
        createdDate TEXT,
        modifiedDate TEXT,
        FOREIGN KEY (site_id) references site(id),
        FOREIGN KEY (customer_id) references customer(id)
      )
    ''');
  await db.x(
      '''CREATE UNIQUE INDEX customer_sites_unq ON customer_site(site_id, customer_id);''');

  await db.x('''
      CREATE TABLE supplier_site(
        site_id integer,
        supplier_id, integer,
        createdDate TEXT,
        modifiedDate TEXT,
        FOREIGN KEY (site_id) references site(id),
        FOREIGN KEY (supplier_id) references supplier(id)
      )
    ''');

  await db.x(
      '''CREATE UNIQUE INDEX supplier_site_unq ON supplier_site(site_id, supplier_id);''');

  await db.x('''
      CREATE TABLE job_site(
        site_id integer,
        job_id integer,
        createdDate TEXT,
        modifiedDate TEXT,
        FOREIGN KEY (site_id) references site(id),
        FOREIGN KEY (job_id) references job(id)
      )
    ''');

  await db
      .x('''CREATE UNIQUE INDEX job_sites_unq ON job_site(site_id, job_id);''');

  /// Create the job_status table and populate it.
  await db.x('''
      CREATE TABLE job_status(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        createdDate TEXT,
        modifiedDate TEXT
      )
    ''');

  await db.x('''
insert into job_status (name, description)
values
('Prospecting', 'A customer has contacted us about a potential job'),
('To be scheduled', 'The customer has agreed to proceed but we have not set a start date'),
('Awaiting Materials', 'The job is paused until materials are available'),
('Completed', 'The Job is completed'),
('To be Billed', 'The Job is completed and needs to be billed'),
('Progress Payment', 'A Job stage has been completed and a progress payment is to be billed'),
('Rejected', 'The Job was rejected by the Customer'),
('On Hold', 'The Job is on hold'),
('In progress', 'The Job is currently in progress')
    ''');

  /// this syntax is invalid so in v6 we drop it.
  await db.x('''
      ALTER TABLE job add col job_status integer''');
}
