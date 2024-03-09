import 'package:json_annotation/json_annotation.dart';
import '../../util/local_date.dart';
import '../types/er.dart';
import '../types/timezone.dart';
import 'call_forward_target.dart';
import 'customer.dart';
import 'entity.dart';

part 'office_holidays.g.dart';

@JsonSerializable()
class OfficeHolidays extends Entity<OfficeHolidays> {
  // The first day that the office is closed
  @ERCustomerConverter()
  ER<Customer> owner;

  // If false then the start/end date should be ignored as holidays are currently active.
  bool active = false;

  // The first day that the office is closed
  @LocalDateConverter()
  LocalDate start = LocalDate.today();

  // The last day that the office is closed
  @LocalDateConverter()
  LocalDate end = LocalDate.today().addDays(7);

  @ERCallForwardTargetConverter()
  ER<CallForwardTarget> callForwardTarget;

  @TimezoneConverter()
  Timezone timezone;

  OfficeHolidays();

  LocalDate nextTransition() {
    if (!active) return null;

    var now = LocalDate.today();

    if (now.isBefore(start)) return start;

    if (now.isBefore(end)) return end;

    return null;
  }

  bool inHolidays() {
    var now = LocalDate.today();

    return active && start.isBeforeOrEqual(now) && end.isAfterOrEqual(now);
  }

  factory OfficeHolidays.fromJson(Map<String, dynamic> json) =>
      _$OfficeHolidaysFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OfficeHolidaysToJson(this);
}
