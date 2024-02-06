import '../repository/repos.dart';
import '../types/guid.dart';

export '../types/guid.dart';

abstract class Entity<T extends Entity<T>> {
  /// Use this version to deserialise a json
  /// object into that sets the id and guid.
  Entity(); //  : _guid = GUID.generate();

  Entity.known(this.id, this.guid);

  /// Use this ctor when constructing
  /// an [Entity] for insertion into the
  /// server side db.
  /// Use this when inserting a new record.
  Entity.forInsert() : guid = GUID.generate();
  int? id;

  @GUIDConverter()
  GUID? guid;

  Future<bool> search(String filter) async => true;

  Map<String, dynamic> toJson();

  T clone(T entity) {
    final json = entity.toJson();

    return Repos().of<T>().fromJson(json);
  }
}
