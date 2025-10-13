import 'package:email_validator/email_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/shelf_multipart.dart';

import 'logger.dart';
import 'mailer.dart';

Future<Response> handleEnquiry(Request request) async {
  try {
    if (!_isMultipart(request)) {
      return Response.badRequest(body: 'Expected formData');
    }

    final params = <String, String>{};

    final formDataRequest = request.formData();
    if (formDataRequest == null) {
      return Response.badRequest(body: 'No form data found');
    }

    await for (final formData in formDataRequest.formData) {
      final dataString = await formData.part.readString();
      params[formData.name] = dataString;
    }

    // Honeypot (ignore/deny spam silently)
    final honeypot = params['website']?.trim() ?? '';
    if (honeypot.isNotEmpty) {
      qlog('Enquiry blocked (honeypot): $honeypot');
      return Response.ok("{result:'success'}"); // pretend success
    }

    // Extract fields
    final name = (params['name'] ?? '').trim();
    final email = params['email']?.trim();
    final phone = (params['phone'] ?? '').trim();
    final description = (params['description'] ?? '').trim();
    final street = (params['address-street'] ?? '').trim();
    final suburb = (params['address-suburb'] ?? '').trim();

    // Dates are optional now
    final day1 = PreferredDate(params, 'day1');
    final day2 = PreferredDate(params, 'day2');
    final day3 = PreferredDate(params, 'day3');

    // Basic validation for enquiry (name, phone, suburb are required)
    if (name.isEmpty || phone.isEmpty || suburb.isEmpty) {
      return Response.badRequest(
        body: '''
Please provide your name, phone number, and suburb so I can call you back.''',
      );
    }

    // Email is optional; if present, validate
    if ((email ?? '').isNotEmpty && !EmailValidator.validate(email!)) {
      return Response.badRequest(
        body:
            '''
Your email address looks invalid. Please correct it or leave it blank, '''
            'or call 0451 086 561 to make an enquiry.',
      );
    }

    qlog('''
New enquiry: name="$name" email="$email" phone="$phone" suburb="$suburb" days=[$day1, $day2, $day3]
''');

    // Send internal notification (to you)
    final sentInternal = await sendEnquiry(
      name: name,
      email: email,
      phone: phone,
      description: description,
      street: street,
      suburb: suburb,
      day1: day1,
      day2: day2,
      day3: day3,
    );

    if (!sentInternal) {
      return Response.internalServerError(
        body:
            '''
Sorry, sending your enquiry failed. Please call 0451 086 561 to make an enquiry.''',
      );
    }

    // Send acknowledgement to the customer (if they supplied an email)
    await sendEnquiryReceived(
      name: name,
      email: email,
      phone: phone,
      description: description,
      street: street,
      suburb: suburb,
      day1: day1,
      day2: day2,
      day3: day3,
    );

    return Response.ok("{result:'success'}");
  } catch (e, st) {
    qlogerr('Error handling enquiry: $e $st');
    return Response.internalServerError(
      body:
          'Sorry, something went wrong submitting your enquiry. '
          'Please call 0451 086 561.',
    );
  }
}

Future<void> sendEnquiryReceived({
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
  // Only send if an email was provided
  if (email == null || email.isEmpty) {
    qlog('No email supplied; skipping enquiry acknowledgement email.');
    return;
  }

  final message = StringBuffer('''
Ivanhoe Handyman Service — Enquiry received<br>
<br>
Thanks for getting in touch, $name.<br>
I'll give you a call (usually within one business day) to discuss your job and, if needed, arrange a time to visit.<br>
<br>
You might find these helpful in the meantime:<br>
• <a href="https://ivanhoehandyman.com.au/#know">Hints & Charges</a><br>
• <a href="https://ivanhoehandyman.com.au/legal.html">Terms &amp; Conditions</a><br>
<br>
<strong>Your details</strong><br>
Name: $name<br>
Phone: $phone<br>
Email: ${email.isEmpty ? 'not supplied' : email}<br>
Address:<br>
&nbsp;&nbsp;Street: ${street.isEmpty ? 'not supplied' : street}<br>
&nbsp;&nbsp;Suburb: $suburb<br>
<br>
<strong>Description</strong><br>
${description.isEmpty ? '(not supplied)' : _htmlEscape(description)}<br>
<br>
<strong>Preferred date windows</strong><br>
${day1.provided ? '$day1<br>' : ''}
${day2.provided ? '$day2<br>' : ''}
${day3.provided ? '$day3<br>' : ''}
<br>
Regards,<br>
Brett<br>
Your Ivanhoe Handyman<br>
''');

  qlog('Sending enquiry acknowledgement to $email');
  await sendEmail(
    from: 'info@ivanhoehandyman.com.au',
    to: email,
    subject: 'Ivanhoe Handyman — Enquiry received',
    body: message.toString(),
  );
}

Future<bool> sendEnquiry({
  required String name,
  required String? email,
  required String phone,
  required String description,
  required PreferredDate day1,
  required PreferredDate day2,
  required PreferredDate day3,
  required String street,
  required String suburb,
}) {
  final message = '''
Ivanhoe Handyman Service — New enquiry<br>
<br>
Name: $name<br>
Phone: $phone<br>
Email: ${email ?? 'not supplied'}<br>
Address:<br>
&nbsp;&nbsp;Street: ${street.isEmpty ? 'not supplied' : street}<br>
&nbsp;&nbsp;Suburb: $suburb<br>
<br>
Description:<br>
${description.isEmpty ? '(not supplied)' : _htmlEscape(description)}<br>
<br>
Preferred date windows:<br>
${day1.provided ? '$day1<br>' : ''}
${day2.provided ? '$day2<br>' : ''}
${day3.provided ? '$day3<br>' : ''}
''';

  qlog('Sending internal enquiry notification');
  return sendEmail(
    from: email ?? 'info@ivanhoehandyman.com.au',
    to: 'bsutton@onepub.dev',
    subject: 'Ivanhoe Handyman — New enquiry',
    body: message,
  );
}

bool _isMultipart(Request request) => request.multipart() != null;

class PreferredDate {
  late final String date;
  late final String ampm;

  PreferredDate(Map<String, String> params, String key) {
    // Support both the new single name (e.g., day1_time=am/pm) and the old separate keys.
    date = (params['$key-date'] ?? 'na').trim();

    // New style: day1_time, day2_time, day3_time
    final time = params['${key}_time']?.trim();

    // Old style: day1-am / day1-pm etc. (value may be "am"/"pm" or "on")
    final am = params['$key-am']?.trim();
    final pm = params['$key-pm']?.trim();

    final resolved =
        time ??
        (am != null && am.isNotEmpty
            ? 'am'
            : (pm != null && pm.isNotEmpty ? 'pm' : ''));

    ampm = resolved.isEmpty ? 'not provided' : resolved;
  }

  @override
  String toString() => '$date $ampm';

  bool get provided => date != 'na';
}

// Simple HTML escape for description (very light)
String _htmlEscape(String s) =>
    s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
