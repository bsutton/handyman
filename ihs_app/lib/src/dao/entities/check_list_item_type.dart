import 'package:json_annotation/json_annotation.dart';

import '../types/er.dart';
import '../types/phone_number.dart';
import 'customer.dart';
import 'entity.dart';

export 'check_list_item.dart';
export 'ivr.dart';
export 'job.dart';
export 'team.dart';
export 'user.dart';

part 'call_forward_target.g.dart';

/// This class MUST only be a nested entity
@JsonSerializable()
class ChecklistItemType extends Entity<ChecklistItemType> {
  factory ChecklistItemType.fromJson(Map<String, dynamic> json) =>
      _$CallForwardTargetFromJson(json);
  @ERCustomerConverter()
  late ER<Customer> owner;

  late String name;

  late String description;

  @override
  String toString() => '$name : $description';

  @override
  Map<String, dynamic> toJson() => _$CallForwardTargetToJson(this);
}
