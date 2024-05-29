import 'package:json_annotation/json_annotation.dart';

import '../types/er.dart';
import 'check_list_item.dart';
import 'entity.dart';
import 'organisation.dart';

part 'checklist_template.g.dart';

@JsonSerializable()
class ChecklistTemplate extends Entity<ChecklistTemplate> {
  ChecklistTemplate();

  factory ChecklistTemplate.fromJson(Map<String, dynamic> json) =>
      _$ChecklistTemplateFromJson(json);
  // The first day that the office is closed
  @ERConverterOrganisation()
  late ER<Organisation> owner;

  late String name;

  @ERConverterChecklistItem()
  List<ER<ChecklistItem>> taskItems = [];

  @override
  Map<String, dynamic> toJson() => _$ChecklistTemplateToJson(this);
}
