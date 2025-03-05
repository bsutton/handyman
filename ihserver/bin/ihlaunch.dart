#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';
import 'package:ihserver/src/config.dart';
import 'package:ihserver/src/logger.dart';
import 'package:path/path.dart';

/// launch the ihserver and restart it if it fails.
/// We expect the ihserver to be in the same directory as the ihlaunch exe
///

void main(List<String> args) {
  print('Logging to: ${Config().pathToLogfile}');
  final pathToIHServer = join(
    dirname(DartScript.self.pathToScript),
    'ihserver',
  );
  qlog('Launching ihserver');

  // start the server and relaunch it if it fails.
  for (;;) {
    final result = pathToIHServer.start(
      nothrow: true,
      progress: Progress(qlog, stderr: qlogerr),
    );
    qlog(red('ihserver failed with exitCode: ${result.exitCode}'));
    qlog('restarting ihserver in 10 seconds');
    sleep(10);
  }
}
