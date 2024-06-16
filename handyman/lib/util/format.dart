import 'package:date_time_format/date_time_format.dart';

String formatDate(DateTime dateTime) =>
    DateTimeFormat.format(dateTime, format: 'D, M j');

String formatDateTime(DateTime dateTime, {bool seconds = false}) {
  final format = 'D, M j, H:i${seconds ? ':s' : ''}';
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
