import 'package:json_annotation/json_annotation.dart';

import '../../util/local_date.dart';
import '../../util/local_time.dart';
import '../enums/forward_calls_to.dart';
import '../types/er.dart';
import 'business_hours_for_day.dart';
import 'call_forward_target.dart';
import 'entity.dart';
import 'team.dart';
import 'user.dart';

part 'override_hours.g.dart';

/// This is the equivalent to a night switch
/// but more sophisticated and applies to a team.
///
/// Should this really be called 'Do Not Disturb' but for teams?
///
@JsonSerializable()
class OverrideHours extends Entity<OverrideHours> {
  // The team that this override record is for.
  @ERJobConverter()
  ER<Team> team;

  // We only allow the user to override the hours for the current day.
  // We track the date so we known when the hours no longer apply.

  @LocalDateConverter()
  @JsonKey(name: 'overrideDate')
  LocalDate overrideDate;

  // the opening and closing times for the overriden date.

  @LocalTimeConverter()
  LocalTime openAt;
  @LocalTimeConverter()
  LocalTime closeAt;

  @ERCallForwardTargetConverter()
  ER<CallForwardTarget> callForwardTarget;

  OverrideHours() {
    OverrideHours._internal(
        null, ForwardCallsTo.VOICEMAIL, MessageMethod.GENERATED, null);
  }

  OverrideHours.defaults(this.team,
      {ForwardCallsTo forwardCallsTo = ForwardCallsTo.VOICEMAIL,
      User colleague}) {
    OverrideHours._internal(
        team, ForwardCallsTo.VOICEMAIL, MessageMethod.GENERATED, colleague);
  }

  OverrideHours._internal(this.team, ForwardCallsTo forwardCallsTo,
      MessageMethod method, User colleague) {
    var defaults = CallForwardTarget();

    defaults.forwardCallsTo = forwardCallsTo;
    defaults.messageMethod = MessageMethod.GENERATED;
    defaults.colleague = (colleague == null ? null : ER(colleague));

    callForwardTarget = ER(defaults);

    overrideDate = LocalDate.today().add(Duration(hours: -1));
  }

  ///
  /// true if the over ride is open for the given date time.
  bool isOpenAt(DateTime asAt) {
    var active = false;

    var asAtDate = LocalDate.fromDateTime(asAt);

    if (overrideDate.isEqual(asAtDate)) {
      var asAtTime = LocalTime.fromDateTime(asAt);

      active =
          openAt.isBeforeOrEqual(asAtTime) && closeAt.isAfterOrEqual(asAtTime);
    }

    return active;
  }

  /// True if we are open due to the user extending the business hours (in the
  /// morning or evening) with this override.
  bool inEarlyOpeningHours(
      DateTime asAt, BusinessHoursForDay normalBusinessHours) {
    var inExtendedOpen = false;

    var asAtDate = LocalDate.fromDateTime(asAt);
    var now = LocalTime.now();

    if (isActiveToday(asAtDate)) {
      var normalOpenAt = normalBusinessHours.openingTime;

      // check for an early opening.
      // are we forcing an early open
      // are we currently open
      // and would we normally be closed.
      if (openAt != null &&
          openAt.isBefore(normalOpenAt) &&
          openAt.isBeforeOrEqual(now) &&
          normalOpenAt.isAfter(now)) {
        inExtendedOpen = true;
      }
    }
    return inExtendedOpen;
  }

  /// true if we are currently closed due to a late opening this override.
  bool inLateOpeningHours(DateTime asAt, BusinessHoursForDay businessHours) {
    var inLateOpen = false;

    var asAtDate = LocalDate.fromDateTime(asAt);
    var now = LocalTime.now();

    if (isActiveToday(asAtDate)) {
      var normalOpenAt = businessHours.openingTime;

      // check for an late open
      // are we forcing a late open
      // are we currently closed
      // and would we normally be open.
      if (openAt != null &&
          openAt.isAfter(normalOpenAt) &&
          openAt.isAfter(now) &&
          normalOpenAt.isBefore(now)) {
        inLateOpen = true;
      }
    }
    return inLateOpen;
  }

  /// true if we are staying open for longer today.
  bool inLateClosingHours(DateTime asAt, BusinessHoursForDay businessHours) {
    var inLateClose = false;

    var asAtDate = LocalDate.fromDateTime(asAt);
    var now = LocalTime.now();

    if (isActiveToday(asAtDate)) {
      var normalCloseAt = businessHours.closingTime;

      // check for an late close
      // are we forcing a late close
      // are we currently open
      // and would we normally be closed.
      if (closeAt != null &&
          closeAt.isAfter(normalCloseAt) &&
          closeAt.isAfter(now) &&
          normalCloseAt.isBefore(now)) {
        inLateClose = true;
      }
    }
    return inLateClose;
  }

  /// True if we are in an early closed due to the user extending the closing hours with this override.
  bool inEarlyClosingHours(DateTime asAt, BusinessHoursForDay businessHours) {
    var inEarlyClose = false;

    var asAtDate = LocalDate.fromDateTime(asAt);
    var now = LocalTime.now();

    if (isActiveToday(asAtDate)) {
      // are we forcing an early close and is the early close already active.

      var normalCloseAt = businessHours.closingTime;

      // check for an early close
      // are we forcing a early close
      // are we currently closed
      // and would we normally be open.
      if (closeAt != null &&
          closeAt.isBefore(normalCloseAt) &&
          closeAt.isBefore(now) &&
          normalCloseAt.isAfter(now)) {
        inEarlyClose = true;
      }
    }
    return inEarlyClose;
  }

  /// True if there is an active override for the given date.
  bool isActiveToday(LocalDate asAt) {
    return overrideDate?.isEqual(asAt) ?? false;
  }

  /// True if the override is active at the given date time.
  bool isActiveNow(DateTime asAt, BusinessHoursForDay businessHours) {
    return isActiveToday(LocalDate.fromDateTime(asAt)) &&
        (inEarlyClosingHours(asAt, businessHours) ||
            inEarlyOpeningHours(asAt, businessHours) ||
            inLateClosingHours(asAt, businessHours) ||
            inLateOpeningHours(asAt, businessHours));
  }

  String getStatusDescription(
      DateTime asAt, BusinessHoursForDay businessHours) {
    var status = '';

    if (inEarlyClosingHours(asAt, businessHours)) {
      status = 'Team have left early today';
    } else if (inEarlyOpeningHours(asAt, businessHours)) {
      status = 'Team have started early today';
    } else if (inLateClosingHours(asAt, businessHours)) {
      status = 'Team are working late today';
    } else if (inLateOpeningHours(asAt, businessHours)) {
      status = 'Team is start late today';
    }

    return status;
  }

  void reset(BusinessHoursForDay businessHours) {
    // set the over-riee date to the past so
    // we know its no longer active.
    overrideDate = LocalDate.today().subtractDays(1);
    openAt = businessHours.openingTime;
    closeAt = businessHours.closingTime;
  }

  factory OverrideHours.fromJson(Map<String, dynamic> json) =>
      _$OverrideHoursFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OverrideHoursToJson(this);
}
