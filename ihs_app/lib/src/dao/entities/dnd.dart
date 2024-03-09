import 'package:json_annotation/json_annotation.dart';
import '../types/er.dart';
import 'call_forward_target.dart';
import 'entity.dart';
import 'user.dart';

part 'dnd.g.dart';

@JsonSerializable()
class DND extends Entity<DND> {
  // The user that this DND record is for.
  @ERUserConverter()
  ER<User> owner;

  // When true, DND is on and endTime is ignored.
  bool forcedOn;

  // If the endTime is in the future then DND is on.
  DateTime _endTime;

  @ERCallForwardTargetConverter()
  ER<CallForwardTarget> callForwardTarget;

  DND(this.owner);

  DateTime get endTime => _endTime;

  set endTime(DateTime endTime) {
    endTime ??= DateTime.now().subtract(Duration(seconds: 1));

    _endTime = endTime;
  }

  bool isDiverted() {
    return forcedOn || _endTime.isAfter(DateTime.now());
  }

  factory DND.fromJson(Map<String, dynamic> json) => _$DNDFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DNDToJson(this);
}
