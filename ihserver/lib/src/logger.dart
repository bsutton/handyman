import 'package:dcli/dcli.dart';

import 'config.dart';

class Logger {
  factory Logger() => _self ??= Logger._();

  Logger._() : pathToLog = Config().pathToLogfile;
  static Logger? _self;
  late final String pathToLog;

  void log(String message) {
    if (pathToLog == 'console') {
      print(message);
    } else {
      pathToLog.append(message);
    }
  }

  void logerr(String message) {
    if (pathToLog == 'print') {
      printerr(message);
    } else {
      pathToLog.append(message);
    }
  }
}

void qlog(String message) => Logger().log(message);
void qlogerr(String message) => Logger().log(message);
