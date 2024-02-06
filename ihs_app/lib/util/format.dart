// ignore_for_file: avoid_classes_with_only_static_members

import 'package:intl/intl.dart';

import 'local_date.dart';
import 'local_time.dart';

class Format {
  ///
  /// Formats the Duration to H:mm
  ///
  /// @param duration
  /// @param showSuffix if true then a suffix such as 'secs' is added to the string.
  ///   defaults to true.
  /// @return a blank string if duration is null otherwise the duration as per the format.
  ///
  ///
  static String duration(Duration duration, {bool showSuffix = true}) {
    if (duration.inHours >= 1) {
      // h:mm
      return '${duration.inHours}'
          ':'
          '${(duration.inMinutes % 60).toString().padLeft(2, '0')}'
          '${showSuffix ? ' min' : ''}';
    } else {
      return '${duration.inMinutes}'
          ':'
          '${(duration.inSeconds % 60).toString().padLeft(2, '0')}'
          '${showSuffix ? ' secs' : ''}';
    }
  }

  static String localDate(LocalDate date, [String pattern = 'yyyy/MM/dd']) =>
      DateFormat(pattern).format(date.toDateTime());

  static String dateTime(DateTime date,
          [String pattern = 'yyyy/MM/dd h:ss a']) =>
      DateFormat(pattern).format(date);

  /// Tries to output the date and time in the minimal format possible/*
  /// If its today just show the time.
  /// If the date is in the last week we show the day name and the time.
  ///  If the date is older than 7 days show the date and the time.
  static String formatNice(DateTime when) {
    final today = LocalDate.today();
    final whenDate = LocalDate.fromDateTime(when);

    if (whenDate.isEqual(today)) {
      // for today just the time.
      return dateTime(when, 'h:mm a');
    } else if (whenDate.add(const Duration(days: 7)).isAfter(today)) {
      // use the day name for the last 7 days.
      return dateTime(when, 'EEEE h:mm a');
    } else {
      return dateTime(when, 'dd MMM h:mm a');
    }
  }

  static String smartFormat(DateTime date,
          [String pattern = 'yyyy/MM/dd h:ss a']) =>
      DateFormat(pattern).format(date);

  static String time(DateTime date, [String pattern = 'h:mm:ss a']) =>
      DateFormat(pattern).format(date);

  static String localTime(LocalTime time, [String pattern = 'h:mm:ss a']) {
    return Format.time(time.toDateTime(), pattern);
    // AMPMParts parts = AMPMParts.fromLocalTime(time);

    // return parts.hour.toString() +
    //     ':' +
    //     parts.minute.toString().padLeft(2, '0') +
    //     (parts.am ? ' am' : ' pm');
  }

  ///
  /// Makes the first character of each word upper case
  ///
  ///  @param name
  /// @return
  ///
  static String toProperCase(String name) {
    final parts = name.split(' ');

    final result = StringBuffer();
    for (var word in parts) {
      if (word.length == 1) {
        word = word.toUpperCase();
      } else if (word.length > 1) {
        word = word.substring(0, 1).toUpperCase() +
            word.substring(1).toLowerCase();
      }

      if (result.length > 0) result.write(' ');

      result.write(word);
    }
    return result.toString();
  }

  ///
  /// Creates a date string suitable for insertion in a message like:
  /// 'We will contact you ${Format.onDate(date)}
  ///
  /// Which results in:
  /// 'tomorrow' if the date is tomorrow
  ///  a day name for the next 7 days in the form: 'on Wednesday'
  /// a day/month if it is within the next year.
  /// a date after that 'on the 2019/7/8'
  ///
  static String onDate(LocalDate date, {bool abbr = false}) {
    String message;

    if (date.isEqual(LocalDate.today())) {
      // not certain this variation makes much sense?
      message = abbr ? 'today' : 'later today';
    } else if (date.addDays(-1).isEqual(LocalDate.today())) {
      message = 'tomorrow';
    } else if (date.addDays(-7).isBefore(LocalDate.today())) {
      if (abbr) {
        message = DateFormat('EEE.').format(date.toDateTime());
      } else {
        message = 'on ${DateFormat('EEEE').format(date.toDateTime())}';
      }
    } else if (date.addDays(-364).isBefore(LocalDate.today())) {
      final ordinal = getDayOrdinal(date);
      if (abbr) {
        final format = '''d'$ordinal' MMM.''';
        message = DateFormat(format).format(date.toDateTime());
      } else {
        final format = '''d'$ordinal' 'of' MMMM''';
        message = 'on the ${DateFormat(format).format(date.toDateTime())}';
      }
    } else {
      message = 'on the ${Format.localDate(date)}';
    }
    return message;
  }

  static String getDayOrdinal(LocalDate date) {
    final day = date.day % 10;

    var ordinal = 'th';

    if (day == 1) {
      ordinal = 'st';
    } else if (day == 2) {
      ordinal = 'nd';
    } else if (day == 3) ordinal = 'rd';

    return ordinal;
  }

  /*

	static const DateFormat dateFormat = DateFormat('dd-MM-yyyy');

	static const DateFormat saasuDateFormat = DateFormat('yyyy-MM-dd');

	static const DateFormat dateWithMonthFormat = DateFormat('dd MMM yyyy');

	static const DateFormat dateFormatTime = DateFormat('dd-MM-yyyy hh:mma');

	static const DateFormat timeFormat = DateFormat('hh:mma');

	 static String format(DateTime date, [ DateFormat formatter = DateFormat.yMEd()])
	{
    return (date == null ? '' : formatter.format(date));
		
	}


	 static String formatWithMonth(DateTime date)
	{
		return format(date, dateWithMonthFormat);
	}

	 static String format(DateTime dateTime)
	{
		return format(dateTime, dateFormatTime);
	}

	 static String format(DateTime dateTime, String pattern)
	{
		return format(dateTime, DateFormat(pattern));
	}

	

	 static String format(LocalTime time, String pattern)
	{
		return format(time, DateFormat(pattern));
	}

	 static String format(DateTime date, DateFormat formater)
	{
		return (date == null ? '' : date.format(formater));
	}

	 static String format(LocalTime time, DateFormat formater)
	{
		return (time == null ? '' : time.format(formater));
	}

	/*
	 * If its today just show the time.
	 * If the date is in the last week we show the day name and the time.
	 * If the date is older than 7 days show the date and the time.
	 */
	 static String formatNice(DateTime when)
	{
		DateTime today = DateTime.now();

		if (when.toDateTime().equals(today))
		{
			// for today just the time.
			return Format.format(when, DateFormat('h:mm a'));
		}
		else

		if (when.plusDays(7).toDateTime().isAfter(today))
		{
			// use the day name for the last 7 days.
			return Format.format(when, DateFormat('EEEE h:mm a'));

		}
		else
			return Format.format(when, DateFormat('dd MMM h:mm a'));

	}

	/**
	 * If the date is today we just display the time. If the date is NOT today we just display the date.
	 * 
	 * @param dateTime
	 * @return
	 */
	 static String formatMinimal(DateTime dateTime)
	{
		if (dateTime.toDateTime().equals(DateTime.now()))
			return format(dateTime.toLocalTime());
		else
			return format(dateTime.toDateTime());
	}

	 static String format(LocalTime time)
	{
		return (time == null ? '' : time.format(timeFormat));
	}

	 static String saasuFormat(DateTime date)
	{
		return (date == null ? '' : date.format(saasuDateFormat));
	}

	

	 static String formatHHmm(Duration duration)
	{
		if (duration == null)
			return '';
		return DurationFormatUtils.formatDuration(duration.toMillis(), 'H:mm');
	}

	/**
	 * Formats the Duration to the given format. Formats support are any supported by
	 * {@link DurationFormatUtils.formatDuration}
	 * 
	 * @param duration
	 * @param format to render duration to.
	 * @return a blank string if duration is null otherwise the duration as per the format.
	 */
	 static String format(Duration duration, String format)
	{

		return (duration == null ? '' : DurationFormatUtils.formatDuration(duration.toMillis(), format));
	}

*/
}

class AMPMParts {
  AMPMParts.fromLocalTime(LocalTime time) {
    minute = time.minute;
    second = time.second;

    if (time.hour == 0) {
      hour = 12;
      am = true;
    } else if (hour == 12) {
      hour = 12;
      am = false;
    } else if (time.hour > 12) {
      hour = time.hour - 12;
      am = false;
    } else {
      hour = time.hour;
      am = true;
    }
  }
  late int hour;
  late int minute;
  late int second;
  late bool am;
}
