import 'entity.dart';

abstract class EntitySettings<E extends Entity<E>> {
  E fromJson(Map<String, dynamic> json);

  /// Overload this method if you need to customize the type name.
  String get entity => E.toString();

  /// Overload this method if you want to restrict the set of fields returned.
  List<String> get selectFields => [];
}
