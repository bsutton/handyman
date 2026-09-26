import 'dart:io';

import 'package:ihserver/src/rotating_log.dart';
import 'package:test/test.dart';

void main() {
  late Directory directory;
  late File log;
  final today = DateTime(2026, 9, 26, 12);

  setUp(() {
    directory = Directory.systemTemp.createTempSync('ihserver-log-');
    log = File('${directory.path}/ihserver.log');
  });
  tearDown(() => directory.deleteSync(recursive: true));

  test('creates and appends without rotating on the same day', () {
    final writer = RotatingLog(log.path, now: () => today)..append('first');
    log.setLastModifiedSync(today);
    writer.append('second');
    expect(log.readAsStringSync(), 'first\nsecond\n');
    expect(File('${log.path}.2026-09-26').existsSync(), isFalse);
  });

  test('rotates on startup and across midnight', () {
    var now = today;
    final writer = RotatingLog(log.path, now: () => now);
    log
      ..writeAsStringSync('yesterday\n')
      ..setLastModifiedSync(DateTime(2026, 9, 25, 23, 59));
    writer.append('today');
    expect(File('${log.path}.2026-09-25').readAsStringSync(), 'yesterday\n');
    log.setLastModifiedSync(today);
    now = DateTime(2026, 9, 27);
    writer.append('tomorrow');
    expect(File('${log.path}.2026-09-26').readAsStringSync(), 'today\n');
    expect(log.readAsStringSync(), 'tomorrow\n');
  });

  test('keeps 30 calendar days and leaves unrelated files untouched', () {
    const retained = [
      '2026-08-28',
      '2026-09-25',
      '2026-02-30',
      'backup',
      '2026-08-01.gz',
    ];
    for (final suffix in ['2026-08-27', ...retained]) {
      File('${log.path}.$suffix').writeAsStringSync(suffix);
    }
    final unrelated = File('${directory.path}/other.log.2026-01-01')
      ..writeAsStringSync('keep');
    RotatingLog(log.path, now: () => today).append('today');
    expect(File('${log.path}.2026-08-27').existsSync(), isFalse);
    for (final suffix in retained) {
      expect(File('${log.path}.$suffix').existsSync(), isTrue);
    }
    expect(unrelated.existsSync(), isTrue);
  });

  test('prunes again on the next day', () {
    var now = today;
    final writer = RotatingLog(log.path, now: () => now);
    final oldest = File('${log.path}.2026-08-28')..writeAsStringSync('old');
    writer.append('today');
    expect(oldest.existsSync(), isTrue);
    log.setLastModifiedSync(today);
    now = DateTime(2026, 9, 27);
    writer.append('tomorrow');
    expect(oldest.existsSync(), isFalse);
  });

  test('preserves an existing archive when rotating a restored log', () {
    final archive = File('${log.path}.2026-09-25')
      ..writeAsStringSync('archived\n');
    log
      ..writeAsStringSync('restored\n')
      ..setLastModifiedSync(DateTime(2026, 9, 25));
    RotatingLog(log.path, now: () => today).append('new');
    expect(archive.readAsStringSync(), 'archived\nrestored\n');
    expect(log.readAsStringSync(), 'new\n');
  });

  test('discards an expired active log after a long shutdown', () {
    log
      ..writeAsStringSync('expired\n')
      ..setLastModifiedSync(DateTime(2025));
    RotatingLog(log.path, now: () => today).append('new');
    expect(File('${log.path}.2025-01-01').existsSync(), isFalse);
    expect(log.readAsStringSync(), 'new\n');
  });

  test('concurrent processes rotate once and preserve every message', () async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    log
      ..writeAsStringSync('old\n')
      ..setLastModifiedSync(yesterday);
    final worker = File('${directory.path}/writer.dart')
      ..writeAsStringSync(r'''
import 'package:ihserver/src/rotating_log.dart';
void main(List<String> args) {
  final log = RotatingLog(args[0]);
  for (var i = 0; i < 100; i++) {
    log.append('${args[1]}:$i');
  }
}
''');
    final results = await Future.wait([
      for (var process = 0; process < 3; process++)
        Process.run(Platform.resolvedExecutable, [
          '--packages=${Directory.current.path}/.dart_tool/package_config.json',
          worker.path,
          log.path,
          '$process',
        ]),
    ]);
    for (final result in results) {
      expect(result.exitCode, 0, reason: '${result.stderr}');
    }
    final archiveDate =
        '${yesterday.year}-'
        '${yesterday.month.toString().padLeft(2, '0')}-'
        '${yesterday.day.toString().padLeft(2, '0')}';
    expect(File('${log.path}.$archiveDate').readAsStringSync(), 'old\n');
    expect(
      log.readAsLinesSync(),
      unorderedEquals([
        for (var process = 0; process < 3; process++)
          for (var line = 0; line < 100; line++) '$process:$line',
      ]),
    );
  });
}
