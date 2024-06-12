import 'package:date_time_format/date_time_format.dart';

String formatDate(DateTime dateTime) =>
    DateTimeFormat.format(dateTime, format: 'D, M j');

String formatDateTime(DateTime dateTime) =>
    DateTimeFormat.format(dateTime, format: 'D, M j, H:i');

String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  return '${hours}h ${minutes}m';
}
