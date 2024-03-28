import 'package:json_annotation/json_annotation.dart';

import '../types/er.dart';
import 'entity.dart';
import 'organisation.dart';

export 'check_list_item.dart';
export 'job.dart';
export 'user.dart';

part 'role.g.dart';

/// The types of roles a contact can have on a job.
@JsonSerializable()
class Role extends Entity<Role> {
  Role();

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
  @ERConverterOrganisation()
  late ER<Organisation> owner;

  late String name;

  late String description;

  @override
  String toString() => '$name : $description';

  @override
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
