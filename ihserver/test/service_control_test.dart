import 'package:ihserver/src/service_control.dart';
import 'package:test/test.dart';

void main() {
  test('matches installed binaries including replaced running executables', () {
    expect(isServiceProcess('/opt/handyman/bin/ihserver', []), isTrue);
    expect(
      isServiceProcess('/opt/handyman/bin/ihlaunch (deleted)', []),
      isTrue,
    );
    expect(
      isServiceProcess('/usr/bin/bash', [
        'bash',
        '/opt/handyman/bin/ihlaunch.sh',
      ]),
      isTrue,
    );
  });

  test('does not stop unrelated processes or the deployment command', () {
    expect(isServiceProcess('/tmp/ihserver', []), isFalse);
    expect(isServiceProcess('/opt/handyman/deploy', []), isFalse);
    expect(
      isServiceProcess('/usr/bin/bash', [
        'bash',
        '-c',
        'cat /opt/handyman/bin/ihlaunch.sh',
      ]),
      isFalse,
    );
    expect(
      isServiceProcess('/usr/bin/cat', [
        'cat',
        '/opt/handyman/bin/ihlaunch.sh',
      ]),
      isFalse,
    );
  });
}
