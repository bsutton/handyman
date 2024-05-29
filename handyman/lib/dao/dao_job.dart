import 'package:sqflite/sqflite.dart';

import '../entity/job.dart';
import 'dao.dart';

class DaoJob extends Dao<Job> {
  @override
  Future<int> insert(covariant Job entity, [Transaction? transaction]) async {
    final db = _db(transaction);
    final id = await db.insert('jobs', entity.toMap()..remove('id'));
    entity.id = id;

    return id;
  }

  DatabaseExecutor _db([Transaction? transaction]) =>
      transaction ?? DatabaseHelper.instance.database;

  @override
  Future<List<Job>> getAll([Transaction? transaction]) async {
    final db = _db(transaction);
    final jobMaps = await db.query('jobs');
    final jobs = <Job>[];

    for (final jobMap in jobMaps) {
      final job = Job.fromMap(jobMap);
      jobs.add(job);
    }

    return jobs;
  }

  @override
  Future<int> update(covariant Job entity, [Transaction? transaction]) async {
    final db = _db(transaction);
    await db.update(
      'jobs',
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );

    return entity.id;
  }

  @override
  Future<int> delete(int id, [Transaction? transaction]) async {
    final db = _db(transaction);

    // Delete tasks associated with the job
    await db.delete(
      'tasks',
      where: 'jobId = ?',
      whereArgs: [id],
    );

    // Delete the job itself
    return db.delete(
      'jobs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
