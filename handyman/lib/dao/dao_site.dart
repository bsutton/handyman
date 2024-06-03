import 'package:sqflite/sqflite.dart';

import '../entity/customer.dart';
import '../entity/site.dart';
import 'dao.dart';

class DaoSite extends Dao<Site> {
  Future<void> createTable(Database db, int version) async {}

  @override
  Site fromMap(Map<String, dynamic> map) => Site.fromMap(map);

  @override
  String get tableName => 'site';

  /// returns the primary site for the customer
  Future<Site?> getPrimaryForCustomer(Customer customer) async {
    final db = getDb();
    final data = await db.rawQuery('''
select s.* from site s
join customer_site sc
  on s.id = sc.site_id
join customer cu
  on sc.customer_id = cu.id
where cu.id =? 
and s.`primary` = 1''', [customer.id]);

    if (data.isEmpty) {
      return null;
    }
    return fromMap(data.first);
  }
}
