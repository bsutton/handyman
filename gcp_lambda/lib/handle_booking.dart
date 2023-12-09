
import 'package:dcli/dcli.dart';
import 'package:shelf/shelf.dart';

import 'mailer.dart';

Future<void> _handleBooking(Request request) async {
  final body = await request.readAsString();
  final uri = Uri(query: body);

  final params = uri
      .queryParameters; // .forEach((key, value) => print('Entry: $key: $value'));

  final name = params['name'];
  final email = params['email'];
  final phone = params['phone'];
  final day1 = PreferredDate(params, 'day1');
  final day2 = PreferredDate(params, 'day2');
  final day3 = PreferredDate(params, 'day3');

  final message = '''
Ivanhoe Handyman Service Booking

Name: $name <br>
Email: $email<br>
Phone: $phone<br>
<br>
Description: <br>
${params['description']}<br>
<br>
Preferred Dates:<br>
$day1<br>
$day2<br>
$day3<br>
''';

  if (email == null) {
    printerr('No email supplied for $name $phone');
    return;
  }

  await sendEmail(
      from: email,
      to: 'bsutton@onepub.dev',
      subject: 'Ivanhoe Handyman Service Booking',
      body: message);
}

class PreferredDate {
  PreferredDate(Map<String, String> params, String key) {
    date = params[key] ?? 'na';
    ampm = params['$key-ampm'] ?? 'na';
  }
  late final String date;
  late final String ampm;

  @override
  String toString() => '$date $ampm';
}