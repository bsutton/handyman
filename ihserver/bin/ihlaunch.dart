#! /usr/bin/env dcli

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:ihserver/src/config.dart';
import 'package:ihserver/src/logger.dart';
import 'package:ihserver/src/service_control.dart';
import 'package:path/path.dart';

/// launch the ihserver and restart it if it fails.
/// We expect the ihserver to be in the same directory as the ihlaunch exe
///

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage.')
    ..addFlag(
      'reload',
      negatable: false,
      help: 'Restart the installed service and exit.',
    )
    ..addFlag('restart', negatable: false, help: 'Alias for --reload.');
  late final ArgResults options;
  try {
    options = parser.parse(args);
    if (options.rest.isNotEmpty) {
      throw const FormatException('Unexpected positional arguments.');
    }
  } on FormatException catch (error) {
    stderr
      ..writeln(error.message)
      ..writeln(parser.usage);
    exitCode = 64;
    return;
  }
  if (options['help'] as bool) {
    print('Usage: ihlaunch [--reload|--restart]\n${parser.usage}');
    return;
  }
  if (options['reload'] as bool || options['restart'] as bool) {
    if (!Shell.current.isPrivilegedProcess) {
      stderr.writeln('Run sudo /opt/handyman/bin/ihlaunch --reload');
      exitCode = 1;
      return;
    }
    await restartService();
    print('Service restart requested. Check /var/log/ihserver.log.');
    return;
  }
  print('Logging to: ${Config().pathToLogfile}');
  final pathToIHServer = join(
    dirname(DartScript.self.pathToScript),
    'ihserver',
  );
  qlog('Launching ihserver');

  // start the server and relaunch it if it fails.
  var retrySeconds = 10;
  for (;;) {
    final uptime = Stopwatch()..start();
    final result = pathToIHServer.start(
      nothrow: true,
      progress: Progress(qlog, stderr: qlogerr),
    );
    qlog(red('ihserver failed with exitCode: ${result.exitCode}'));
    if (uptime.elapsed >= const Duration(minutes: 5)) {
      retrySeconds = 10;
    }
    qlog('restarting ihserver in $retrySeconds seconds');
    sleep(retrySeconds);
    retrySeconds = (retrySeconds * 2).clamp(10, 300);
  }
}
