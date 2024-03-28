import 'package:json_annotation/json_annotation.dart';

import '../types/er.dart';
import 'customer.dart';
import 'entity.dart';

part 'check_list_item_type.g.dart';

/// This class MUST only be a nested entity
@JsonSerializable()
class ChecklistItemType extends Entity<ChecklistItemType> {
// required by json
  ChecklistItemType();

  factory ChecklistItemType.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemTypeFromJson(json);

  @ERConverterCustomer()
  late ER<Customer> owner;

  late String name;

  late String description;

  @override
  String toString() => '$name : $description';

  @override
  Map<String, dynamic> toJson() => _$ChecklistItemTypeToJson(this);
}
