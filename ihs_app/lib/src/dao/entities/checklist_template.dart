import 'package:json_annotation/json_annotation.dart';

import '../../util/local_date.dart';
import '../types/er.dart';
import '../types/timezone.dart';
import 'check_list_item_type.dart';
import 'customer.dart';
import 'entity.dart';
import 'organisation.dart';

part 'office_holidays.g.dart';

@JsonSerializable()
class ChecklistTemplate extends Entity<ChecklistTemplate> {
  factory ChecklistTemplate.fromJson(Map<String, dynamic> json) =>
      _$ChecklistTemplateFromJson(json);
  // The first day that the office is closed
  @ERConverterOrganisation()
  late ER<Organisation> owner;

  late String name;

  List<ER<ChecklistItem>> taskItems = [];

  @override
  Map<String, dynamic> toJson() => _$ChecklistTemplateToJson(this);
}
