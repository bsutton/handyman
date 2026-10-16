import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:booking_request/booking_request.dart';
import 'package:ihserver/src/booking_request_store.dart';
import 'package:ihserver/src/config.dart';
import 'package:ihserver/src/handle_booking_requests.dart';
import 'package:revault_api/revault_api.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late Directory original;
  late Directory temp;
  final store = BookingRequestStore();

  setUpAll(() async {
    original = Directory.current;
    temp = Directory.systemTemp.createTempSync('ihserver-bookings-');
    Directory.current = temp;
    Directory('config').createSync();
    File('config/config.yaml').writeAsStringSync('''
path_to_static_content: www
fqdn: example.invalid
domain_email: test@example.invalid
use_https: true
''');
    await Revault.load();
    final password = SecretString.fromString('synthetic-booking-password');
    try {
      final box = Lockbox.create('config/ihserver.lbox', password: password);
      try {
        for (final entry in {
          '/gmail_app_username': 'test@example.invalid',
          '/gmail_app_password': 'synthetic-mail-password',
          '/hmb_api_token': 'synthetic-api-token',
        }.entries) {
          final value = SecretBytes.take(
            Uint8List.fromList(utf8.encode(entry.value)),
          );
          try {
            box.setSecretVariable(entry.key, value);
          } finally {
            value.close();
          }
        }
        box.commit();
      } finally {
        box.close();
      }
      await Config().unlock('synthetic-booking-password');
    } finally {
      password.close();
    }
  });

  tearDownAll(() {
    Directory.current = original;
    temp.deleteSync(recursive: true);
  });

  setUp(() {
    File('config/booking_requests.json').writeAsStringSync('[]');
  });

  Future<BookingRequest> addRequest() => store.add(
    businessName: '',
    firstName: 'Test',
    surname: 'Customer',
    email: 'customer@example.com',
    phone: '',
    description: 'Repair a door',
    street: '',
    suburb: '',
    day1: '',
    day2: '',
    day3: '',
  );

  Request request(String endpoint, {Object? body, bool authorized = true}) =>
      Request(
        body == null ? 'GET' : 'POST',
        Uri.parse('https://example.invalid/api/hmb/booking/$endpoint'),
        headers: {
          if (authorized) 'Authorization': 'Bearer synthetic-api-token',
          'Content-Type': 'application/json',
        },
        body: body == null ? null : jsonEncode(body),
      );

  test('fetch retains requests; ack removes only confirmed imports', () async {
    final received = await addRequest();
    final pending = await addRequest();
    final response = await handleBookingRequests(request('requests'));
    expect(response.statusCode, 200);
    expect(await store.listAll(), hasLength(2));

    final ack = await handleBookingAck(
      request(
        'ack',
        body: {
          'ids': [received.id],
        },
      ),
    );
    expect(ack.statusCode, 200);
    expect(await store.getById(received.id), isNull);
    expect((await store.listAll()).single.id, pending.id);
    expect((await store.listNew()).single.id, pending.id);
    final saved =
        jsonDecode(File('config/booking_requests.json').readAsStringSync())
            as List<dynamic>;
    expect(saved, hasLength(1));
    expect((saved.single as Map<String, dynamic>)['id'], pending.id);

    // Retries after a lost acknowledgement response must remain successful.
    expect(
      (await handleBookingAck(
        request(
          'ack',
          body: {
            'ids': [received.id, received.id, 'unknown'],
          },
        ),
      )).statusCode,
      200,
    );
    expect((await store.listAll()).single.id, pending.id);
  });

  test('invalid or unauthorized acknowledgements retain requests', () async {
    final pending = await addRequest();
    expect(
      (await handleBookingAck(
        request(
          'ack',
          body: {
            'ids': [pending.id],
          },
          authorized: false,
        ),
      )).statusCode,
      403,
    );
    expect(
      (await handleBookingAck(
        request('ack', body: {'ids': 'invalid'}),
      )).statusCode,
      400,
    );
    expect((await store.listAll()).single.id, pending.id);
  });

  test(
    'removes previously imported records while retaining pending ones',
    () async {
      final imported = await addRequest();
      final pending = await addRequest();
      File('config/booking_requests.json').writeAsStringSync(
        jsonEncode([
          {...imported.toJson(), 'imported': true},
          pending.toJson(),
        ]),
      );

      expect((await store.listAll()).single.id, pending.id);
      final saved =
          jsonDecode(File('config/booking_requests.json').readAsStringSync())
              as List<dynamic>;
      expect(saved, hasLength(1));
      expect((saved.single as Map<String, dynamic>)['id'], pending.id);
    },
  );

  test('app can email a rejection after acknowledging receipt', () async {
    final received = await addRequest();
    await store.removeAcknowledged([received.id]);
    String? recipient;
    final response = await handleBookingReject(
      request(
        'reject',
        body: {
          'id': received.id,
          'reason': 'Fully booked',
          'delivery_method': 'email',
          'destination': received.email,
        },
      ),
      sendRejectionEmail:
          ({
            required from,
            required to,
            required subject,
            required body,
          }) async {
            recipient = to;
            expect(body, contains('Fully booked'));
            return true;
          },
    );
    expect(response.statusCode, 200);
    expect(recipient, received.email);
    expect(await store.listAll(), isEmpty);
  });

  test('rejection validates destination and delivery before sending', () async {
    for (final payload in [
      {'delivery_method': 'email', 'destination': 'invalid'},
      {'delivery_method': 'sms', 'destination': 'customer@example.com'},
    ]) {
      final response = await handleBookingReject(
        request(
          'reject',
          body: {
            'id': 'already-imported',
            'reason': 'Fully booked',
            ...payload,
          },
        ),
        sendRejectionEmail:
            ({
              required from,
              required to,
              required subject,
              required body,
        }) {
              fail('Invalid rejection must not send email');
            },
      );
      expect(response.statusCode, 400);
    }
  });
}
