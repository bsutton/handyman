import 'package:json_annotation/json_annotation.dart';

import '../../util/local_date.dart';
import '../../util/local_time.dart';
import '../types/er.dart';
import 'business_hours_for_day.dart';
import 'check_list_item_type.dart';
import 'entity.dart';
import 'team.dart';
import 'user.dart';

part 'organisation.g.dart';

/// This is the equivalent to a night switch
/// but more sophisticated and applies to a team.
///
/// Should this really be called 'Do Not Disturb' but for teams?
///
@JsonSerializable()
class Organisation extends Entity<Organisation> {

  late String name;


  factory Organisation.fromJson(Map<String, dynamic> json) =>
      _$OrganisationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OrganisationToJson(this);
}
