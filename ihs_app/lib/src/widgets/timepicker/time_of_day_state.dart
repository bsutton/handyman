import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../util/local_time.dart';

class LocalTimeState extends ChangeNotifier {
  // 12 hour clock.
  int hour;
  int minute;

  /// current state of the am/pm buttons
  bool am;

  LocalTimeState(LocalTime localTime) {
    hour = localTime.hour;
    minute = localTime.minute;

    if (hour >= 12) {
      am = false;
    } else {
      am = true;
    }
    // convert to 12 hour clock.
    if (hour > 12) {
      hour -= 12;
    }
  }

  void updateMinute(int buttonMinute) {
    minute = buttonMinute;
    notifyListeners();
  }

  void updateHour(int buttonHour) {
    hour = buttonHour;
    notifyListeners();
  }

  void setAMPM({@required bool am}) {
    this.am = am;
    notifyListeners();
  }

  bool isAM() {
    return am;
  }

  bool isPM() {
    return !am;
  }

  DateTime asDateTime() {
    var today = DateTime.now();
    DateTime result;
    var time = asLocalTime();

    // is the picked time in the future?
    if (today.hour < time.hour || today.hour == time.hour && today.minute < time.minute) {
      result = DateTime(today.year, today.month, today.day, time.hour, time.minute);
    } else {
      // picked time is in the past so we assume they mean tomorrow.
      var tomorrow = today.add(Duration(days: 1));
      result = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, time.hour, time.minute);
    }
    return result;
  }

  LocalTime asLocalTime() {
    var hour = _as24Hour();

    return LocalTime(hour: hour, minute: minute, second: 0);
  }

  int _as24Hour() {
    var hour24 = hour;

    if (am) {
      if (hour == 12) {
        hour24 = 0;
      } else {
        hour24 = hour;
      }
    } else // pm
    {
      if (hour == 12) {
        hour24 = hour;
      } else {
        hour24 = hour + 12;
      }
    }

    return hour24;
  }
}

class TimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(String json) {
    return json == null ? null : TimeOfDay.fromDateTime(DateTime.parse('2000-01-01 $json'));
  }

  @override
  String toJson(TimeOfDay timeOfDay) {
    return timeOfDay == null ? '' : ('${timeOfDay.hour}:${timeOfDay.minute}');
  }
}
