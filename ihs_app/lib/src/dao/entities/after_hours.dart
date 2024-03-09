import 'package:json_annotation/json_annotation.dart';

import '../types/er.dart';
import 'call_forward_target.dart';
import 'entity.dart';

part 'after_hours.g.dart';

@JsonSerializable()
class Note extends Entity<Note> {
  factory Note.fromJson(Map<String, dynamic> json) =>
      _$AfterHoursFromJson(json);
  // The Job that this Note belongs to.
  @ERJobConverter()
  ER<Job> job;

  @ERCallForwardTargetConverter()
  ER<CallForwardTarget> callForardTarget;

  Note();

  @override
  Map<String, dynamic> toJson() => _$AfterHoursToJson(this);
}
