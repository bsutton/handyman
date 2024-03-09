import 'package:json_annotation/json_annotation.dart';

import '../types/er.dart';
import 'check_list_item_type.dart';
import 'entity.dart';

part 'check_list.g.dart';

@JsonSerializable()
class Checklist extends Entity<Checklist> {
  Checklist();
  factory Checklist.fromJson(Map<String, dynamic> json) =>
      _$ChecklistFromJson(json);
  // The Job that this Note belongs to.
  @ERJobConverter()
  List<ER<Job>> checkListItem = [];

  @override
  Map<String, dynamic> toJson() => _$ChecklistToJson(this);
}
