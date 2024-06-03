import 'package:sqflite/sqflite.dart';

import '../database_extension.dart';

Future<void> applyV10(Database db) async {
  await db.x('''
        ALTER TABLE customer drop  primarySurname ; 
        ALTER TABLE customer drop  primaryAddressLine1 ;
        ALTER TABLE customer drop  primaryAddressLine2 ;
        ALTER TABLE customer drop  primarySuburb ;
        ALTER TABLE customer drop  primaryState ;
        ALTER TABLE customer drop  primaryPostcode ;
        ALTER TABLE customer drop  primaryMobileNumber ;
        ALTER TABLE customer drop  primaryLandLine ;
        ALTER TABLE customer drop  primaryOfficeNumber ;
        ALTER TABLE customer drop  primaryEmailAddress ;
        ALTER TABLE customer drop  secondarySurname ;
        ALTER TABLE customer drop  secondaryAddressLine1 ;
        ALTER TABLE customer drop  secondaryAddressLine2 ;
        ALTER TABLE customer drop  secondarySuburb ;
        ALTER TABLE customer drop  secondaryState ;
        ALTER TABLE customer drop  secondaryPostcode ;
        ALTER TABLE customer drop  secondaryMobileNumber ;
        ALTER TABLE customer drop  secondaryLandLine ;
        ALTER TABLE customer drop  secondaryOfficeNumber ;
        ALTER TABLE customer drop  secondaryEmailAddress ;
    ''');

  await db.x('''
  alter table contact add column `primary` integer;
''');

  await db.x('''
  alter table site add column `primary` integer;
''');
}
