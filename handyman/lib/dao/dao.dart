import 'package:sqflite/sqflite.dart';

import '../entity/entities.dart';

export 'dao_customer.dart';
export 'database_helper.dart';

abstract class Dao {
  Future<int> insert(Entity entity, [Transaction? transaction]);

  Future<int> update(Entity entity, [Transaction? transaction]);

  Future<int> delete(int id, [Transaction? transaction]);

  Future<List<Entity>> getAll();
}
