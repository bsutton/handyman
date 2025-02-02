import 'package:email_validator/email_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/shelf_multipart.dart';

import 'logger.dart';
import 'mailer.dart';

Future<Response> handleBooking(Request request) async {
  try {
    if (!_isMultipart(request)) {
      return Response.badRequest(body: 'Expected formData');
    }

    final params = <String, String>{};

    final formDataRequest = request.formData();

    if (formDataRequest == null) {
      return Response.badRequest(body: 'No form Data found');
    }
    await for (final formData in formDataRequest.formData) {
      final dataString = await formData.part.readString();
      params[formData.name] = dataString;
    }

    final name = params['name'] ?? 'not supplied';
    final email = params['email'];
    final phone = params['phone'] ?? 'not supplied';
    final description = params['description'] ?? 'not supplied';
    final street = params['address-street'] ?? 'not supplied';
    final suburb = params['address-suburb'] ?? 'not supplied';

    final day1 = PreferredDate(params, 'day1');
    final day2 = PreferredDate(params, 'day2');
    final day3 = PreferredDate(params, 'day3');

    qlog('New Booking details: $name $email $phone $day1 $day2 $day3');

    if (!EmailValidator.validate(email ?? 'invalid')) {
      return Response.badRequest(body: '''
Your email address looks to be invalid. Please correct it or call 0451 086 561 to make a booking ''');
    }

    if (!await sendBooking(
        name: name,
        email: email,
        phone: phone,
        description: description,
        street: street,
        suburb: suburb,
        day1: day1,
        day2: day2,
        day3: day3)) {
      return Response.internalServerError(
          body:
              '''Sorry but the booking attempt fail. Please call 0451 086 561 to make a booking''');
    }

    await sendBookingReceived(
        name: name,
        email: email,
        phone: phone,
        description: description,
        street: street,
        suburb: suburb,
        day1: day1,
        day2: day2,
        day3: day3);

    return Response.ok("{result:'success'}");

    // ignore: avoid_catches_without_on_clauses
  } catch (e, st) {
    qlogerr('Error handling booking: $e $st');
    return Response.internalServerError(
        body:
            '''Sorry but the booking attempt fail. Please call 0451 086 561 to make a booking''');
  }
}

Future<void> sendBookingReceived({
  required String name,
  required String? email,
  required String phone,
  required String description,
  required String street,
  required String suburb,
  required PreferredDate day1,
  required PreferredDate day2,
  required PreferredDate day3,
}) async {
  final message = StringBuffer('''
Ivanhoe Handyman Service - Your booking has been received<br>
 <br>
Thanks for trusting me with your job, I always aim to please. <br>
 <br>
You should hear back from me within one business day to confirm the  <br>
details of your booking and the job date. <br>
 <br>
Once everything is agreed, I will send you a payment link for the call out fee <br>
which needs to be paid to 3 business days before the agreed job date to confirm your booking. <br>
 <br>
In the meantime, please read the <a href="ivanhoehandyman.com.au">'Hints' and 'Charges'</a> section on the  <br>
Ivanhoe Handyman site to ensure there are no surprises.<br>
<br>
When making the booking you will have clicked the 'I agree to the terms and conditions' but did you read the  <br>
<a href="ivanhoehandyman.com.au/legal.html">T&Cs</a>? <br>
It is short and in plain english. <br>
 <br>
The details you provided are: <br>
Name: $name <br>
  Email: $email<br>
  Phone: $phone<br>
  Address: <br>
  Street: $street<br>
  Suburb: $suburb<br>
  <br>
  Description: <br>
  $description<br>
  <br>
  Preferred Dates:<br>
  ''');

  if (day1.provided) {
    message.write('$day1<br>');
  }
  if (day2.provided) {
    message.write('$day2<br>');
  }

  if (day3.provided) {
    message.write('$day3<br>');
  }

  message.write('''
<br>
<br>
  Regards,<br>
  Brett<br>
  Your Ivanhoe Handyman.<br>
  <br>
  ''');

  if (email == null) {
    qlogerr('Unable to send booking received as no email supplied: $message');
  } else {
    qlog('Sending booking confirmaiton: $message');

    await sendEmail(
        from: 'info@ivanhoehandyman.com.au',
        to: email,
        subject: 'Ivanhoe Handyman Service Booking Received',
        body: message.toString());
  }
}

Future<bool> sendBooking(
    {required String name,
    required String? email,
    required String phone,
    required String description,
    required PreferredDate day1,
    required PreferredDate day2,
    required PreferredDate day3,
    required String street,
    required String suburb}) async {
  final message = '''
Ivanhoe Handyman Service Booking<br>
<br>
Name: $name <br>
  Email: $email<br>
  Phone: $phone<br>
  Address: <br>
  Street: $street<br>
  Suburb: $suburb<br>
  <br>
  Description: <br>
  $description<br>
  <br>
  Preferred Dates:<br>
  $day1<br>
  $day2<br>
  $day3<br>
  ''';

  qlog('Sending booking: $message');
  return sendEmail(
      from: email ?? 'notsupplied@ivanhohandyman.com.au',
      to: 'bsutton@onepub.dev',
      subject: 'Ivanhoe Handyman Service Booking',
      body: message);
}

bool _isMultipart(Request request) => request.multipart() != null;
// return multipart != null && multipart.isMultipart && request.isMultipartForm;

class PreferredDate {
  PreferredDate(Map<String, String> params, String key) {
    date = params['$key-date'] ?? 'na';
    final am = params['$key-am'];
    ampm = am ?? params['$key-pm'] ?? 'not provided';
  }
  late final String date;
  late final String ampm;

  @override
  String toString() => '$date $ampm';

  bool get provided => date != 'na';
}
