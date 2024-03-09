import 'package:json_annotation/json_annotation.dart';
import '../../util/format.dart';
import '../../util/local_date.dart';
import '../types/er.dart';
import 'call_forward_target.dart';
import 'entity.dart';
import 'user.dart';

part 'leave.g.dart';

@JsonSerializable()
class Leave extends Entity<Leave> {
  // The user that this leave record is for.
  @ERUserConverter()
  ER<User> owner;

  // If false then the start/end date should be ignored as leave is currently active.
  bool active = false;

  // The first day that the user is on leave
  @LocalDateConverter()
  LocalDate startDate = LocalDate.today();

  // The last day that the user is on leave
  @LocalDateConverter()
  LocalDate endDate = LocalDate.today().addDays(7);

  @ERCallForwardTargetConverter()
  ER<CallForwardTarget> callForwardTarget;

  Leave(this.owner);

  LocalDate getStart() {
    return startDate;
  }

  LocalDate getEnd() {
    return endDate;
  }

  /// Returns a formatted date for the next holiday
  /// period if the leave is active and the end date
  /// lies in the future.
  String nextTransition(LocalDate asAt) {
    // if (!inHolidays(asAt)) return null;

    if (!active) return null;

    // if no holidays planned then show nothing.
    if (startDate == null && endDate == null) return null;

    // holidays are in the past.
    if (endDate.isBefore(asAt)) return null;

    // holidays are booked for the future.
    if (startDate != null && asAt.isBefore(startDate)) {
      // only display holidays that are no more that 1 year away.
      if (startDate.addDays(-365).isBefore(asAt)) {
        return "Start: ${Format.localDate(startDate, "MMM d")}";
      } else {
        return null;
      }
    }

    // user is currently on holidays.
    if ((startDate == null && endDate.isAfterOrEqual(asAt)) ||
        (startDate != null &&
            startDate.isBeforeOrEqual(asAt) &&
            endDate.isAfterOrEqual(asAt))) {
      return "Until ${Format.localDate(endDate, "MMM d")}";
    }

    return null;
  }

  /// Returns true if the given date is within a users holiday period
  /// We only consider a holiday period if the period is active.
  bool inHolidays(LocalDate asAt) {
    if (!active) return false;
    if (startDate == null && endDate == null) {
      return false;
    }
    if (startDate == null && endDate.isAfterOrEqual(asAt)) {
      return true;
    }
    if (endDate == null && startDate.isBeforeOrEqual(asAt)) {
      return true;
    }
    return startDate.isBeforeOrEqual(asAt) && endDate.isAfterOrEqual(asAt);
  }

  factory Leave.fromJson(Map<String, dynamic> json) => _$LeaveFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LeaveToJson(this);
}
