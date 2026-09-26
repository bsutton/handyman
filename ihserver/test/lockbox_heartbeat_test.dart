import 'package:ihserver/src/lockbox_heartbeat.dart';
import 'package:test/test.dart';

void main() {
  const url = 'https://uptime.betterstack.com/api/v1/heartbeat/synthetic';
  test('locked state reports failure, unlocked state reports success', () {
    expect(
      LockboxHeartbeat.endpoint(url, unlocked: false).toString(),
      '$url/fail',
    );
    expect(LockboxHeartbeat.endpoint('$url/', unlocked: true).toString(), url);
  });
  test('invalid endpoint errors do not disclose URL tokens', () {
    for (final invalid in [
      'http://example.invalid/canary',
      '$url/fail',
      '$url?canary',
    ]) {
      expect(
        () => LockboxHeartbeat.endpoint(invalid, unlocked: false),
        throwsA(
          isA<FormatException>().having(
            (e) => e.toString(),
            'safe error',
            isNot(contains('canary')),
          ),
        ),
      );
    }
  });
}
