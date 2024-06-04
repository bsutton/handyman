import 'package:sqflite/sqflite.dart';

import '../entity/contact.dart';
import '../entity/customer.dart';
import 'dao.dart';
import 'dao_contact_customer.dart';

class DaoContact extends Dao<Contact> {
  Future<void> createTable(Database db, int version) async {}

  @override
  Contact fromMap(Map<String, dynamic> map) => Contact.fromMap(map);

  @override
  String get tableName => 'contact';

  /// returns the primary contact for the customer
  Future<Contact?> getPrimaryForCustomer(Customer customer) async {
    final db = getDb();
    final data = await db.rawQuery('''
select co.* from contact co
join customer_contact cc
  on co.id = cc.contact_id
join customer cu
  on cc.customer_id = cu.id
where cu.id =? 
and cc.`primary` = 1''', [customer.id]);

    if (data.isEmpty) {
      return null;
    }
    return fromMap(data.first);
  }

  Future<List<Contact>> getByCustomer(Customer? customer) async {
    final db = getDb();

    if (customer == null) {
      return [];
    }
    final data = await db.rawQuery('''
select co.* from contact co
join customer_contact cc
  on co.id = cc.contact_id
join customer cu
  on cc.customer_id = cu.id
where cu.id =? 
''', [customer.id]);

    return toList(data);
  }

  Future<void> deleteFromCustomer(Contact contact, Customer customer) async {
    await DaoContactCustomer().deleteJoin(customer, contact);
    await delete(contact.id);
  }

  Future<void> insertForCustomer(Contact contact, Customer customer) async {
    await insert(contact);
    await DaoContactCustomer().insertJoin(contact, customer);
    await delete(contact.id);
  }
}
