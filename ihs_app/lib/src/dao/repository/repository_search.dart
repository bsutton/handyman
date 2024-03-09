import '../entities/entity.dart';
import '../transaction/query.dart';
import 'repository.dart';

mixin RepositorySearch<E extends Entity<E>> on Repository<E> {
  Query searchQuery(String? filter, {int offset, int limit});

  Future<List<E>> search(
    String filter, {
    int offset = 0,
    int limit = 0,
    bool force = false,
  }) =>
      select(searchQuery(filter, offset: offset, limit: limit), force: force);

  Future<int> countSearch(
    String? filter, {
    bool force = false,
  }) =>
      count(searchQuery(filter), force: force);
}
