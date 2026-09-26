import 'dart:io';

import 'package:ihserver/src/certificate_request_backoff.dart';
import 'package:test/test.dart';

void main() {
  late Directory directory;
  late DateTime now;
  late int attempts;
  CertificateRequestBackoff policy() =>
      CertificateRequestBackoff(directory, now: () => now);
  Future<bool> fail() async {
    attempts++;
    return false;
  }

  setUp(() {
    directory = Directory.systemTemp.createTempSync('acme-backoff-');
    now = DateTime.utc(2026, 9, 26);
    attempts = 0;
  });
  tearDown(() => directory.deleteSync(recursive: true));

  test('restart cannot retry a failed authorization within an hour', () async {
    expect(await policy().request('example.com', fail), isFalse);
    now = now.add(const Duration(minutes: 59, seconds: 59));
    await expectLater(
      policy().request('example.com', fail),
      throwsA(isA<CertificateRequestDeferred>()),
    );
    expect(attempts, 1);
    now = now.add(const Duration(seconds: 1));
    expect(await policy().request('example.com', fail), isFalse);
    expect(attempts, 2);
  });

  test(
    'persists reservation before calling ACME, including thrown errors',
    () async {
      await expectLater(
        policy().request('example.com', () async {
          await expectLater(
            policy().request('example.com', fail),
            throwsA(isA<CertificateRequestDeferred>()),
          );
          throw StateError('ACME rejected the order');
        }),
        throwsStateError,
      );
      await expectLater(
        policy().request('example.com', fail),
        throwsA(isA<CertificateRequestDeferred>()),
      );
      expect(attempts, 0);
    },
  );

  test('failures back off to 24 hours, independently per domain', () async {
    for (final hours in [1, 2, 4, 8, 16, 24, 24]) {
      await policy().request('example.com', fail);
      now = now.add(Duration(hours: hours) - const Duration(seconds: 1));
      await expectLater(
        policy().request('example.com', fail),
        throwsA(isA<CertificateRequestDeferred>()),
      );
      now = now.add(const Duration(seconds: 1));
    }
    expect(attempts, 7);
    expect(await policy().request('other.example.com', fail), isFalse);
  });

  test('success clears failure count', () async {
    await policy().request('example.com', fail);
    now = now.add(const Duration(hours: 1));
    expect(await policy().request('example.com', () async => true), isTrue);
    await policy().request('example.com', fail);
    now = now.add(const Duration(hours: 1));
    expect(await policy().request('example.com', fail), isFalse);
  });

  test('corrupt state prevents further ACME calls', () async {
    await policy().request('example.com', fail);
    directory
        .listSync()
        .whereType<File>()
        .singleWhere((f) => f.path.endsWith('.json'))
        .writeAsStringSync('invalid');
    await expectLater(
      policy().request('example.com', fail),
      throwsFormatException,
    );
    expect(attempts, 1);
  });
}
