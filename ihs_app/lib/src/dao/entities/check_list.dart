import 'package:json_annotation/json_annotation.dart';

import '../types/er.dart';
import 'entity.dart';
import 'job.dart';

part 'check_list.g.dart';

@JsonSerializable()
class Checklist extends Entity<Checklist> {
  Checklist();
  factory Checklist.fromJson(Map<String, dynamic> json) =>
      _$ChecklistFromJson(json);
  // The Job that this Note belongs to.
  @ERConverterJob()
  List<ER<Job>> checkListItem = [];

  @override
  Map<String, dynamic> toJson() => _$ChecklistToJson(this);
}
