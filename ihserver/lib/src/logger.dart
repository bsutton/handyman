import 'package:dcli/dcli.dart';

import 'config.dart';
import 'rotating_log.dart';

class Logger {
  static Logger? _self;

  late final String pathToLog;
  late final _file = RotatingLog(pathToLog);

  bool get _console => pathToLog == 'console' || pathToLog == 'print';

  factory Logger() => _self ??= Logger._();

  Logger._() : pathToLog = Config().pathToLogfile;

  void log(String message) {
    if (_console) {
      print(message);
    } else {
      _file.append(message);
    }
  }

  void logerr(String message) {
    if (_console) {
      printerr(message);
    } else {
      _file.append(message);
    }
  }
}

void qlog(String message) => Logger().log(message);
void qlogerr(String message) => Logger().logerr(message);
