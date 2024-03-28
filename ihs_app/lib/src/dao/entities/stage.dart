import 'package:json_annotation/json_annotation.dart';

import '../types/er.dart';
import 'entity.dart';
import 'organisation.dart';

export 'check_list_item.dart';
export 'job.dart';
export 'user.dart';

part 'stage.g.dart';

/// The the stage the job is in.
@JsonSerializable()
class Stage extends Entity<Stage> {
  Stage();
  factory Stage.fromJson(Map<String, dynamic> json) => _$StageFromJson(json);
  @ERConverterOrganisation()
  late ER<Organisation> owner;

  late String name;

  late String description;

  @override
  String toString() => '$name : $description';

  @override
  Map<String, dynamic> toJson() => _$StageToJson(this);
}
