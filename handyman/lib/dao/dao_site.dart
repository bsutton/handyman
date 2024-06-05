import 'package:sqflite/sqflite.dart';

import '../entity/customer.dart';
import '../entity/job.dart';
import '../entity/site.dart';
import '../entity/supplier.dart';
import 'dao.dart';
import 'dao_site_customer.dart';
import 'dao_site_job.dart';
import 'dao_site_supplier.dart';

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

  /// returns the primary site for the supplier
  Future<Site?> getPrimaryForSupplier(Supplier? supplier) async {
    if (supplier == null) {
      return null;
    }

    final db = getDb();
    final data = await db.rawQuery('''
select s.* from site s
join supplier_site sc
  on s.id = sc.site_id
join supplier cu
  on sc.supplier_id = cu.id
where cu.id =? 
and sc.`primary` = 1''', [supplier.id]);

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

  Future<List<Site>> getBySupplier(Supplier? supplier) async {
    final db = getDb();

    if (supplier == null) {
      return [];
    }
    final data = await db.rawQuery('''
select s.* from site s
join supplier_site sc
  on s.id = sc.site_id
join supplier cu
  on sc.supplier_id = cu.id
where cu.id =? 
''', [supplier.id]);

    return toList(data);
  }

  Future<List<Site>> getByJob(Job? job) async {
    final db = getDb();

    if (job == null) {
      return [];
    }
    final data = await db.rawQuery('''
select si.* 
from site si
join job_site js
  on si.id = js.site_id
join job jo
  on js.job_id = jo.id
where jo.id =? 
''', [job.id]);

    return toList(data);
  }

  Future<void> deleteFromCustomer(Site site, Customer customer) async {
    await DaoSiteCustomer().deleteJoin(customer, site);
    await delete(site.id);
  }

  Future<void> insertForCustomer(Site site, Customer customer) async {
    await insert(site);
    await DaoSiteCustomer().insertJoin(site, customer);
  }

  Future<void> deleteFromSupplier(Site site, Supplier supplier) async {
    await DaoSiteSupplier().deleteJoin(supplier, site);
    await delete(site.id);
  }

  Future<void> insertForSupplier(Site site, Supplier supplier) async {
    await insert(site);
    await DaoSiteSupplier().insertJoin(site, supplier);
  }

  Future<void> deleteFromJob(Site site, Job job) async {
    await DaoSiteJob().deleteJoin(job, site);
    await delete(site.id);
  }

  Future<void> insertForJob(Site site, Job job) async {
    await insert(site);
    await DaoSiteJob().insertJoin(site, job);
  }
}
