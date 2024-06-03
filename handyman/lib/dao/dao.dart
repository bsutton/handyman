import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/entity.dart';
import 'management/database_helper.dart';

export 'dao_customer.dart';
export 'management/database_helper.dart';

abstract class Dao<T extends Entity<T>> {
  /// Insert [entity] into the database.
  Future<int> insert(covariant T entity, [Transaction? transaction]) async {
    final db = getDb(transaction);
    final id = await db.insert(tableName, entity.toMap()..remove('id'));
    entity.id = id;
    return id;
  }

  Future<List<T>> getAll([Transaction? transaction]) async {
    final db = getDb(transaction);
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => fromMap(maps[i]));
  }

  Future<T?> getById(int? entityId) {
    final db = getDb();
    return db
        .query(tableName, where: 'id =?', whereArgs: [entityId]).then((value) {
      if (value.isEmpty) {
        return null;
      }
      return fromMap(value.first);
    });
  }

  Future<int> update(covariant T entity, [Transaction? transaction]) async {
    final db = getDb(transaction);
    return db.update(
      tableName,
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }

  Future<int> delete(int id, [Transaction? transaction]) async {
    final db = getDb(transaction);
    return db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @protected
  List<T> toList(List<Map<String, Object?>> data) {
    if (data.isEmpty) {
      return [];
    }
    return List.generate(data.length, (i) => fromMap(data[i]));
  }

  T fromMap(Map<String, dynamic> map);

  DatabaseExecutor getDb([Transaction? transaction]) =>
      transaction ?? DatabaseHelper.instance.database;

  String get tableName;
}
