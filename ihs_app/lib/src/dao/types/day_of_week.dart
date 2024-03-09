import 'package:json_annotation/json_annotation.dart';

/// Enum for days of the week.
/// Monday = 0, Sunday = 6.
enum DayName { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }

/// A 1 based day of the week.
/// Monday = 1, Sunday = 7
class DayOfWeek {
  final int weekday;

  /// The [weekday] must be between 1 (Monday) and 7 (Sunday).
  DayOfWeek(this.weekday) {
    assert(weekday >= 1 && weekday <= 7);
  }
  DayOfWeek.fromDateTime(DateTime dateTime) : this(dateTime.weekday);
  DayOfWeek.fromDayName(DayName dayName) : this(_getWeekDay(dayName));

  /// Returns a string representation of the day name for the give date.
  /// If abbreviate is false (the default) then the full day name 'Sunday' is returned.
  /// If abbreviate is true then then a three letter abbreviation is returned 'Sun'.
  ///
  String dayName({bool abbreviate = false}) {
    if (abbreviate) {
      return _getAbbreviation();
    } else {
      return _getFullnameOfEnum(getEnum());
    }
  }

  DayName getEnum() {
    return DayName.values.elementAt(weekday - 1);
  }

  static int _getWeekDay(DayName dayName) {
    var resultday = -1;
    var index = 1;

    for (var value in DayName.values) {
      if (value == dayName) {
        resultday = index;
      }
      index++;
    }

    return resultday;
  }

  ///
  /// Returns the abbreviated version (3 character) name of the dayName
  ///
  String _getAbbreviation() {
    return _getFullnameOfEnum(getEnum()).substring(0, 3);
  }

  static String _getAbbreviationOfEnum(DayName dayName) {
    return _getFullnameOfEnum(dayName).substring(0, 3);
  }

  ///
  /// Returns the fullname of the passed dayName. e.g. Monday
  ///
  static String _getFullnameOfEnum(DayName dayName) {
    var fullName = dayName.toString();
    var period = fullName.indexOf('.');

    return fullName.substring(period + 1);
  }

  ///
  /// Takes an abbreviated (3 character) dayname and returns
  /// the DayName
  ///
  static DayOfWeek fromAbbreviation(String abbreviatedName) {
    for (var dayName in DayName.values) {
      if (_getAbbreviationOfEnum(dayName) == abbreviatedName) {
        return DayOfWeek(dayName.index + 1);
      }
    }

    throw ArgumentError('Unknown abbreviation: $abbreviatedName');
  }

  /// A 1 based day of the week.
  /// Monday = 1, Sunday = 7
  int asInt() {
    return _getWeekDay(getEnum());
  }
}

class DayOfWeekConverter implements JsonConverter<DayOfWeek, int> {
  const DayOfWeekConverter();

  @override
  DayOfWeek fromJson(int dayOfWeek) {
    // String raw = json['dayofweek'] as String;
    return DayOfWeek(dayOfWeek);
  }

  @override
  int toJson(DayOfWeek dayOfWeek) {
    return dayOfWeek.asInt();
  }
}
