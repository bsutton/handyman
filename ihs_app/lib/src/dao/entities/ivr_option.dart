import 'package:json_annotation/json_annotation.dart';
import '../types/er.dart';
import 'call_forward_target.dart';
import 'entity.dart';

part 'ivr_option.g.dart';

@JsonSerializable()
class IVROption extends Entity<IVROption> {
  int ordinal;
  String name;

  @ERCallForwardTargetConverter()
  ER<CallForwardTarget> callForwardTarget;

  IVROption(this.ordinal);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(covariant IVROption rhs) {
    return (ordinal == rhs.ordinal);
  }

  factory IVROption.fromJson(Map<String, dynamic> json) =>
      _$IVROptionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IVROptionToJson(this);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => ordinal.hashCode;
}
