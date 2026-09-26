import 'package:test/test.dart';

import '../tool/scp_command.dart';

void main() {
  const source = '/home/user/project/build/install/bundle';
  const destination = '/opt/handyman/.install-123';
  const prefix =
      '/usr/bin/scp -r -i /home/user/.ssh/google_compute_engine '
      '-o CheckHostIP=no -o HashKnownHosts=no -o HostKeyAlias=compute.123 '
      '-o IdentitiesOnly=yes -o StrictHostKeyChecking=yes '
      '-o UserKnownHostsFile=/home/user/.ssh/google_compute_known_hosts';

  test(
    'corrects the actual gcloud IPv6 output, preserving every other argument',
    () {
      final command = parseGcloudScp(
        '$prefix $source user@2600:1900:4180:bfa7:0:1:0:0:$destination\n',
        source: source,
        destination: destination,
      );
      expect(command.executable, '/usr/bin/scp');
      expect(command.arguments, [
        '-r',
        '-i',
        '/home/user/.ssh/google_compute_engine',
        '-o',
        'CheckHostIP=no',
        '-o',
        'HashKnownHosts=no',
        '-o',
        'HostKeyAlias=compute.123',
        '-o',
        'IdentitiesOnly=yes',
        '-o',
        'StrictHostKeyChecking=yes',
        '-o',
        'UserKnownHostsFile=/home/user/.ssh/google_compute_known_hosts',
        source,
        'user@[2600:1900:4180:bfa7:0:1:0:0]:$destination',
      ]);
    },
  );

  for (final host in [
    'user@[2001:db8::1]',
    'user@192.0.2.1',
    'user@example.com',
  ]) {
    test('leaves $host unchanged', () {
      final command = parseGcloudScp(
        '$prefix $source $host:$destination',
        source: source,
        destination: destination,
      );
      expect(command.arguments.last, '$host:$destination');
    });
  }

  test('preserves spaces and shell metacharacters as literal arguments', () {
    const local = r'/tmp/my files/$data;$(touch nope)/bundle';
    final command = parseGcloudScp(
      '/usr/bin/scp -r -i /home/a user/key -o UserKnownHostsFile=/home/a user/hosts $local user@2001:db8::1:$destination',
      source: local,
      destination: destination,
    );
    expect(command.arguments, [
      '-r',
      '-i',
      '/home/a user/key',
      '-o',
      'UserKnownHostsFile=/home/a user/hosts',
      local,
      'user@[2001:db8::1]:$destination',
    ]);
  });

  for (final output in [
    '/usr/bin/scp -r wrong-source user@2001:db8::1:$destination',
    '$prefix $source user@2001:db8::1:/wrong-path',
    '/usr/bin/other -r $source user@2001:db8::1:$destination',
    '/usr/bin/scp -Z $source user@2001:db8::1:$destination',
    'unexpected output\n$prefix $source user@2001:db8::1:$destination',
  ]) {
    test('rejects unexpected output: $output', () {
      expect(
        () => parseGcloudScp(output, source: source, destination: destination),
        throwsFormatException,
      );
    });
  }
}
