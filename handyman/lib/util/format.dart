import 'package:date_time_format/date_time_format.dart';

String formatDate(DateTime dateTime) =>
    DateTimeFormat.format(dateTime, format: 'D, M j, H:i');
