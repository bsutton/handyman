import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'booking_request_store.dart';
import 'hmb_auth.dart';
import 'logger.dart';
import 'mailer.dart';

Future<Response> handleBookingRequests(Request request) async {
  if (!isHmbAuthorized(request)) {
    return Response.forbidden('Forbidden');
  }

  final store = BookingRequestStore();
  final pending = await store.listNew();
  final payload = pending.map((r) => r.toJson()).toList();
  return Response.ok(
    jsonEncode({'requests': payload}),
    headers: {'Content-Type': 'application/json'},
  );
}

/// Once the client has imported the booking requests,
/// it calls this endpoint to acknowledge the request
/// and we delete them from the store.
Future<Response> handleBookingAck(Request request) async {
  if (!isHmbAuthorized(request)) {
    return Response.forbidden('Forbidden');
  }

  try {
    final body = await request.readAsString();
    final decoded = jsonDecode(body) as Map<String, dynamic>;
    final ids = (decoded['ids'] as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    final store = BookingRequestStore();
    await store.markImported(ids);
    return Response.ok(
      jsonEncode({'acknowledged': ids.length}),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    qlog('Failed to ack booking requests: $e');
    return Response.badRequest(body: 'Invalid request payload');
  }
}

/// The user/handyman rejected the booking request with a
/// reason. We send an email to the enquirer with the reason.
Future<Response> handleBookingReject(Request request) async {
  if (!isHmbAuthorized(request)) {
    return Response.forbidden('Forbidden');
  }

  try {
    final body = await request.readAsString();
    final decoded = jsonDecode(body) as Map<String, dynamic>;
    final id = decoded['id']?.toString().trim();
    final reason = decoded['reason']?.toString().trim() ?? '';

    if (id == null || id.isEmpty || reason.isEmpty) {
      return Response.badRequest(body: 'Missing id or reason');
    }

    final store = BookingRequestStore();
    final requestData = await store.getById(id);
    if (requestData == null) {
      return Response.notFound('Booking request not found');
    }

    final data = requestData.data;
    final email = data['email']?.toString().trim() ?? '';
    final name = data['name']?.toString().trim() ?? 'there';

    if (email.isEmpty) {
      return Response.badRequest(body: 'Booking request has no email address');
    }

    final message = '''
Ivanhoe Handyman Service — Enquiry update<br>
<br>
Hi ${_htmlEscape(name)},<br>
<br>
Thanks for your enquiry. Unfortunately, I won’t be able to proceed at this time.<br>
<br>
Reason:<br>
${_htmlEscape(reason)}<br>
<br>
Regards,<br>
Brett<br>
Your Ivanhoe Handyman<br>
''';

    final sent = await sendEmail(
      from: 'info@ivanhoehandyman.com.au',
      to: email,
      subject: 'Ivanhoe Handyman — Enquiry update',
      body: message,
    );

    if (!sent) {
      return Response.internalServerError(
        body: 'Failed to send rejection email',
      );
    }

    return Response.ok(
      jsonEncode({'rejected': true}),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    qlog('Failed to reject booking request: $e');
    return Response.badRequest(body: 'Invalid request payload');
  }
}

String _htmlEscape(String s) =>
    s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
