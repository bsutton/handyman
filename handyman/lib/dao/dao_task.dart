import 'package:sqflite/sqflite.dart';

import '../entity/job.dart';
import '../entity/task.dart';
import 'dao.dart';

class DaoTask extends Dao<Task> {
  @override
  Future<int> insert(covariant Task entity, [Transaction? transaction]) async {
    final db = _db(transaction);
    final id = await db.insert('tasks', entity.toMap()..remove('id'));
    entity.id = id;
    return id;
  }

  DatabaseExecutor _db([Transaction? transaction]) =>
      transaction ?? DatabaseHelper.instance.database;

  Future<List<Task>> getTasksByJob(Job job) async {
    final db = _db();

    final results =
        await db.query('task', where: 'jobid = ?', whereArgs: [job.id]);

    final tasks = <Task>[];
    for (final result in results) {
      tasks.add(Task.fromMap(result));
    }
    return tasks;
  }

  @override
  Future<List<Task>> getAll([Transaction? transaction]) async {
    final db = _db(transaction);
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  @override
  Future<int> update(covariant Task entity, [Transaction? transaction]) async {
    final db = _db(transaction);
    return db.update(
      'tasks',
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }

  @override
  Future<int> delete(int id, [Transaction? transaction]) async {
    final db = _db(transaction);
    return db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
