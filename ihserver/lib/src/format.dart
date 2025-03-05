import 'package:date_time_format/date_time_format.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime dateTime, {String format = 'D, j M'}) =>
    DateTimeFormat.format(dateTime, format: format);

String formatDateTime(DateTime dateTime, {bool seconds = false}) {
  final format = 'D, j M, H:i${seconds ? ':s' : ''}';
  return DateTimeFormat.format(dateTime, format: format);
}

String formatDateTimeAM(DateTime dateTime, {bool seconds = false}) {
  final format = 'D, j M, h:i${seconds ? ':s' : ''} a';
  return DateTimeFormat.format(dateTime, format: format);
}

String formatDuration(Duration duration, {bool seconds = false}) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  final result = '${hours}h ${minutes}m';
  if (seconds) {
    final seconds = duration.inSeconds.remainder(60);
    return '$result ${seconds}s';
  }

  return result;
}

String formatTime(DateTime date, [String format = 'h:mm:ss a']) =>
    DateFormat(format).format(date);

DateFormat dateFormat = DateFormat('yyyy-MM-dd hh:mm a');

DateTime? parseDateTime(String? value) => dateFormat.tryParse(value ?? '');
