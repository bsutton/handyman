import 'package:june/june.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/site.dart';
import '../entity/supplier.dart';
import 'dao.dart';

class DaoSiteSupplier extends Dao<Site> {
  Future<void> createTable(Database db, int version) async {}

  @override
  Site fromMap(Map<String, dynamic> map) => Site.fromMap(map);

  @override
  String get tableName => 'supplier_site';

  Future<void> deleteJoin(Supplier supplier, Site site,
      [Transaction? transaction]) async {
    await getDb(transaction).delete(
      tableName,
      where: 'supplier_id = ? and site_id = ?',
      whereArgs: [supplier.id, site.id],
    );
  }

  Future<void> insertJoin(Site site, Supplier supplier,
      [Transaction? transaction]) async {
    await getDb(transaction).insert(
      tableName,
      {'supplier_id': supplier.id, 'site_id': site.id},
    );
  }

  Future<void> setAsPrimary(Site site, Supplier supplier,
      [Transaction? transaction]) async {
    await getDb(transaction).update(
      tableName,
      {'primary': 1},
      where: 'supplier_id = ? and site_id = ?',
      whereArgs: [supplier.id, site.id],
    );
  }

  @override
  JuneStateCreator get juneRefresher => SiteSupplierState.new;
}

/// Used to notify the UI that the time entry has changed.
class SiteSupplierState extends JuneState {
  SiteSupplierState();
}