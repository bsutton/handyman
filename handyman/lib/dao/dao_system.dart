import 'package:sqflite/sqflite.dart';

import '../entity/system.dart';
import 'dao.dart';

class DaoSystem extends Dao<System> {
  Future<void> createTable(Database db, int version) async {}

  @override
  System fromMap(Map<String, dynamic> map) => System.fromMap(map);

  Future<System?> get() async => getById(1);

  @override
  String get tableName => 'system';
}
