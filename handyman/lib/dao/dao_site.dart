import 'package:sqflite/sqflite.dart';

import '../entity/customer.dart';
import '../entity/site.dart';
import 'dao.dart';
import 'dao_site_customer.dart';

class DaoSite extends Dao<Site> {
  Future<void> createTable(Database db, int version) async {}

  @override
  Site fromMap(Map<String, dynamic> map) => Site.fromMap(map);

  @override
  String get tableName => 'site';

  /// returns the primary site for the customer
  Future<Site?> getPrimaryForCustomer(Customer? customer) async {
    if (customer == null) {
      return null;
    }

    final db = getDb();
    final data = await db.rawQuery('''
select s.* from site s
join customer_site sc
  on s.id = sc.site_id
join customer cu
  on sc.customer_id = cu.id
where cu.id =? 
and sc.`primary` = 1''', [customer.id]);

    if (data.isEmpty) {
      return null;
    }
    return fromMap(data.first);
  }

  Future<List<Site>> getByCustomer(Customer? customer) async {
    final db = getDb();

    if (customer == null) {
      return [];
    }
    final data = await db.rawQuery('''
select s.* from site s
join customer_site sc
  on s.id = sc.site_id
join customer cu
  on sc.customer_id = cu.id
where cu.id =? 
''', [customer.id]);

    return toList(data);
  }


  Future<void> deleteFromCustomer(Site site, Customer customer) async {
    await DaoSiteCustomer().deleteJoin(customer, site);
    await delete(site.id);
  }

  Future<void> insertForCustomer(Site site, Customer customer) async {
    await DaoSiteCustomer().insertJoin(site, customer);
    await delete(site.id);
  }
}
