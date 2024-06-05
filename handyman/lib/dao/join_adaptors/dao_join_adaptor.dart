import '../../entity/entity.dart';

abstract class DaoJoinAdaptor<C extends Entity<C>, P extends Entity<P>> {
  Future<List<C>> getByParent(P? parent);
  void insertForParent(C child, P parent);
  void deleteFromParent(C child, P parent);
}
