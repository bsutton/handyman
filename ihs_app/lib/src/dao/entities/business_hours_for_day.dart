import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../util/local_time.dart';
import '../../widgets/timepicker/time_of_day_state.dart';
import '../types/day_of_week.dart';
import '../types/er.dart';
import 'customer.dart';
import 'entity.dart';
import 'team.dart';

part 'business_hours_for_day.g.dart';

@JsonSerializable()
class BusinessHoursForDay extends Entity<BusinessHoursForDay> {
  @ERCustomerConverter()
  ER<Customer> owner;

  @ERJobConverter()
  ER<Team> team;

  @DayOfWeekConverter()
  DayOfWeek dayOfWeek;

  // True if the office is open on this day.
  bool open;

  // The times are stored in the users
  @LocalTimeConverter()
  LocalTime openingTime;

  @LocalTimeConverter()
  LocalTime closingTime;

  bool isOpenAt(LocalTime time) {
    return time.isAfterOrEqual(openingTime) &&
        time.isBeforeOrEqual(closingTime);
  }

  BusinessHoursForDay();

  BusinessHoursForDay.create(DayName dayName,
      {@required this.open,
      @required this.openingTime,
      @required this.closingTime})
      : dayOfWeek = DayOfWeek.fromDayName(dayName);

  void updateOpeningTime(LocalTimeState timeOfDayState) {
    openingTime = timeOfDayState.asLocalTime();
  }

  void updateClosingTime(LocalTimeState timeOfDayState) {
    closingTime = timeOfDayState.asLocalTime();
  }

  String dayName() {
    return dayOfWeek.dayName();
  }

  factory BusinessHoursForDay.fromJson(Map<String, dynamic> json) =>
      _$BusinessHoursForDayFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BusinessHoursForDayToJson(this);
}
