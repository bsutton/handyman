import 'package:json_annotation/json_annotation.dart';

/// Enum for days of the week.
/// Monday = 0, Sunday = 6.
enum DayName { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

/// A 1 based day of the week.
/// Monday = 1, Sunday = 7
class DayOfWeek {
  /// The [weekday] must be between 1 (Monday) and 7 (Sunday).
  DayOfWeek(this.weekday)
      : assert(weekday >= 1 && weekday <= 7, 'Not a valid day no.');
  DayOfWeek.fromDateTime(DateTime dateTime) : this(dateTime.weekday);
  DayOfWeek.fromDayName(DayName dayName) : this(_getWeekDay(dayName));

  final int weekday;

  /// Returns a string representation of the day name for the give date.
  /// If abbreviate is false (the default) then the full day name 'Sunday'
  ///  is returned.
  /// If abbreviate is true then then a three letter abbreviation is
  ///  returned 'Sun'.
  ///
  String dayName({bool abbreviate = false}) {
    if (abbreviate) {
      return _getAbbreviation();
    } else {
      return _getFullnameOfEnum(getEnum());
    }
  }

  DayName getEnum() => DayName.values.elementAt(weekday - 1);

  static int _getWeekDay(DayName dayName) {
    var resultday = -1;
    var index = 1;

    for (final value in DayName.values) {
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
  String _getAbbreviation() => _getFullnameOfEnum(getEnum()).substring(0, 3);

  static String _getAbbreviationOfEnum(DayName dayName) =>
      _getFullnameOfEnum(dayName).substring(0, 3);

  ///
  /// Returns the fullname of the passed dayName. e.g. Monday
  ///
  static String _getFullnameOfEnum(DayName dayName) {
    final fullName = dayName.toString();
    final period = fullName.indexOf('.');

    return fullName.substring(period + 1);
  }

  ///
  /// Takes an abbreviated (3 character) dayname and returns
  /// the DayName
  ///
  static DayOfWeek fromAbbreviation(String abbreviatedName) {
    for (final dayName in DayName.values) {
      if (_getAbbreviationOfEnum(dayName) == abbreviatedName) {
        return DayOfWeek(dayName.index + 1);
      }
    }

    throw ArgumentError('Unknown abbreviation: $abbreviatedName');
  }

  /// A 1 based day of the week.
  /// Monday = 1, Sunday = 7
  int asInt() => _getWeekDay(getEnum());
}

class DayOfWeekConverter implements JsonConverter<DayOfWeek, int> {
  const DayOfWeekConverter();

  @override
  DayOfWeek fromJson(int dayOfWeek) => DayOfWeek(dayOfWeek);

  @override
  int toJson(DayOfWeek dayOfWeek) => dayOfWeek.asInt();
}
