import 'dart:io';

import 'package:test/test.dart';

import '../tool/remote.dart';

void main() {
  late Directory temporary;
  late List<List<String>> calls;

  setUp(() {
    temporary = Directory.systemTemp.createTempSync('ihserver-deploy-test-');
    Directory('${temporary.path}/bundle/bin').createSync(recursive: true);
    File('${temporary.path}/bundle/bin/install').writeAsStringSync('installer');
    calls = [];
  });
  tearDown(() => temporary.deleteSync(recursive: true));

  RemoteDeployment remote({bool ipv6 = true, int? failAt}) => RemoteDeployment(
    server: 'handyman',
    directory: '/opt/handyman',
    project: 'test',
    zone: 'test-a',
    bundle: '${temporary.path}/bundle',
    capture: (arguments) async {
      calls.add(arguments);
      if (calls.length == failAt) {
        throw ProcessException('gcloud', arguments, 'test failure', 1);
      }
      final destination = arguments.last.substring('handyman:'.length);
      final host = ipv6 ? '2001:db8::1' : '192.0.2.1';
      return '/usr/bin/scp -r -i /home/user/.ssh/google_compute_engine '
          '-o HostKeyAlias=compute.123 ${temporary.path}/bundle user@$host:$destination';
    },
    runScp: (executable, arguments) async {
      expect(executable, '/usr/bin/scp');
      calls.add(arguments);
      if (calls.length == failAt) {
        throw ProcessException(executable, arguments, 'test failure', 1);
      }
    },
    run: (arguments) async {
      calls.add(arguments);
      if (calls.length == failAt) {
        throw ProcessException('gcloud', arguments, 'test failure', 1);
      }
    },
  );

  test('uploads full bundle before remote install using IPv6', () async {
    await remote().deploy();
    expect(calls.length, 5);
    expect(calls[1], contains('--dry-run'));
    expect(calls[1], contains('--recurse'));
    expect(calls[1].last, startsWith('handyman:/opt/handyman/'));
    expect(calls[2].last, startsWith('user@[2001:db8::1]:/opt/handyman/'));
    expect(calls[2], contains('HostKeyAlias=compute.123'));
    expect(calls[3].last, startsWith('--command=sudo '));
    expect(calls[3].last, contains('/bundle/bin/install'));
    expect(calls[4].last, startsWith('--command=rm -rf -- '));
    expect(
      calls.expand((call) => call).any((arg) => arg.contains('HostName=')),
      isFalse,
    );
  });

  test('upload failure prevents installation', () async {
    await expectLater(
      remote(failAt: 3).deploy(),
      throwsA(isA<ProcessException>()),
    );
    expect(calls.length, 3);
  });

  test('installation failure retains uploaded bundle', () async {
    await expectLater(
      remote(failAt: 4).deploy(),
      throwsA(isA<ProcessException>()),
    );
    expect(calls.length, 4);
  });

  test('reload runs only remote reload, without needing a build', () async {
    Directory('${temporary.path}/bundle').deleteSync(recursive: true);
    await remote(ipv6: false).reload();
    expect(
      calls.single.last,
      "--command=sudo '/opt/handyman/bin/ihlaunch' --reload",
    );
    expect(calls.single, isNot(contains('--ssh-flag=-6')));
  });

  test('dry-run failure prevents upload and installation', () async {
    await expectLater(
      remote(failAt: 2).deploy(),
      throwsA(isA<ProcessException>()),
    );
    expect(calls.length, 2);
  });

  test('missing installer fails before connecting', () async {
    Directory('${temporary.path}/bundle').deleteSync(recursive: true);
    await expectLater(remote().deploy(), throwsA(isA<FileSystemException>()));
    expect(calls, isEmpty);
  });
}
