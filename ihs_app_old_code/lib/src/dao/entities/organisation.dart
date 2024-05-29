import 'package:json_annotation/json_annotation.dart';

import 'entity.dart';

part 'organisation.g.dart';

/// This is the equivalent to a night switch
/// but more sophisticated and applies to a team.
///
/// Should this really be called 'Do Not Disturb' but for teams?
///
@JsonSerializable()
class Organisation extends Entity<Organisation> {
  Organisation();

  Organisation.forInsert({required this.name}) : super.forInsert();

  factory Organisation.fromJson(Map<String, dynamic> json) =>
      _$OrganisationFromJson(json);

  late String name;

  @override
  Map<String, dynamic> toJson() => _$OrganisationToJson(this);
}
