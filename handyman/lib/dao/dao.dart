import 'package:sqflite/sqflite.dart';

import '../entity/entity.dart';

export 'dao_customer.dart';
export 'database_helper.dart';

abstract class Dao<T extends Entity> {
  Future<int> insert(T entity, [Transaction? transaction]);

  Future<int> update(T entity, [Transaction? transaction]);

  Future<int> delete(int id, [Transaction? transaction]);

  Future<List<T>> getAll();
}
