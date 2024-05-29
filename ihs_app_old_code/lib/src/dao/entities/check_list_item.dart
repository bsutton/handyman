import 'package:json_annotation/json_annotation.dart';

import '../types/er.dart';
import 'check_list_item_type.dart';
import 'entity.dart';
import 'organisation.dart';

part 'check_list_item.g.dart';

@JsonSerializable()
class ChecklistItem extends Entity<ChecklistItem> {
  ChecklistItem();
  factory ChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemFromJson(json);

  @ERConverterOrganisation()
  late ER<Organisation> owner;

  late DateTime created = DateTime.now();

  late String name;

  @ERConverterChecklistItemType()
  late ER<ChecklistItemType> checkListItemType;

  DateTime getCreated() => created;

  @override
  Map<String, dynamic> toJson() => _$ChecklistItemToJson(this);
}
