import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';

import 'entity.dart';

part 'activity.g.dart';

@JsonSerializable()
class Activity extends Entity<Activity> {
  // required by Json
  Activity();

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
  late String comment;

  late DateTime createdDate;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => hash2(comment, createdDate);

  @override
  Map<String, dynamic> toJson() => _$ActivityToJson(this);
  

}
