import 'package:sqflite/sqflite.dart';

import '../entity/customer.dart';
import '../entity/site.dart';
import 'dao.dart';

class DaoSiteCustomer extends Dao<Site> {
  Future<void> createTable(Database db, int version) async {}

  @override
  Site fromMap(Map<String, dynamic> map) => Site.fromMap(map);

  @override
  String get tableName => 'customer_site';

  Future<void> deleteJoin(Customer customer, Site site,
      [Transaction? transaction]) async {
    await getDb(transaction).delete(
      tableName,
      where: 'customer_id = ? and site_id = ?',
      whereArgs: [customer.id, site.id],
    );
  }

  Future<void> insertJoin(Site site, Customer customer,
      [Transaction? transaction]) async {
    await getDb(transaction).insert(
      tableName,
      {'customer_id': customer.id, 'site_id': site.id},
    );
  }
}