import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/form_data.dart';
import 'package:shelf_multipart/multipart.dart';

import 'logger.dart';
import 'mailer.dart';

Future<Response> handleBooking(Request request) async {
  // final body = await request.readAsString();
  // final uri = Uri(query: body);

  if (!_isMultipart(request)) {
    return Response.badRequest(body: 'Exported formData');
  }

  // final params = uri.queryParameters;
  final params = <String, String>{};

  await for (final formData in request.multipartFormData) {
    final dataString = await formData.part.readString();
    final parts = dataString.split(':');
    params[parts[0]] = parts[1];
  }
  // Map<String, dynamic>? params = await request.multipartFormData;

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
    qlogerr('No email supplied for $name $phone');
    return Response.badRequest(body: 'No email supplied for $name $phone');
  }

  await sendEmail(
      from: email,
      to: 'bsutton@onepub.dev',
      subject: 'Ivanhoe Handyman Service Booking',
      body: message);

  return Response.ok("{result:'success'}");
}

bool _isMultipart(Request request) =>
    request.isMultipart && request.isMultipartForm;

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
