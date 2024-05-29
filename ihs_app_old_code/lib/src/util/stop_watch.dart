import 'dart:core' as core show Stopwatch;
import 'dart:core' hide Stopwatch;

import 'package:stacktrace_impl/stacktrace_impl.dart';

import 'log.dart';

///
/// [StopWatch] is designed to provide profiling information
/// by tracking the time between two lines of code.
///
/// ```dart
/// StopWatch stopWatch = StopWatch('Doing Fetch', showStackTrace = true);
///
/// ... do some fetching
///
/// stopWatch.end(); // logs the time
/// ```
class StopWatch {
  StopWatch({required this.description, this.showStackTrace = false})
      : stackTrace = StackTraceImpl(skipFrames: 1) {
    stopWatch.start();
  }
  final core.Stopwatch stopWatch = core.Stopwatch();
  final StackTraceImpl stackTrace;
  final bool showStackTrace;
  String description;

  Duration get runtime => Duration(milliseconds: stopWatch.elapsedMilliseconds);

  void end({bool log = true}) {
    stopWatch.stop();

    description = '$description ';
    if (log) {
      Log.d(
          '''Elapsed ${stopWatch.elapsedMilliseconds} ms for $description${stackTrace.sourceFilename}:${stackTrace.lineNo}''',
          stackTrace: showStackTrace ? stackTrace : null);
    }
  }
}
