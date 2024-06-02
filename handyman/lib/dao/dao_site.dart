import 'package:sqflite/sqflite.dart';

import '../entity/site.dart';
import 'dao.dart';

class DaoSite extends Dao<Site> {
  Future<void> createTable(Database db, int version) async {}

  @override
  Site fromMap(Map<String, dynamic> map) => Site.fromMap(map);

  @override
  String get tableName => 'site';
}
