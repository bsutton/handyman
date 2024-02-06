import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:stacktrace_impl/stacktrace_impl.dart';
import '../widgets/theme/nj_theme.dart';
import 'local_ticker_provider.dart';
import 'log.dart';

/// A short cut to displaying a SnackBar.
///
/// ```dart
/// QuickSnack().error(context, "Something bad happend");
/// QuickSnack().info(context, "Did you know that...", duration: Duration(5))
/// QuickSnack().warn(context, "Look out");
/// QuickSnack().undo(context,   duration: Duration(5), 'Undo delete', () => something.undoit());
/// ```
class QuickSnack {
  static const QuickSnack _self = QuickSnack._internal();
  static Flushbar _undoBar;

  static final showing = <Flushbar>[];

  factory QuickSnack() {
    return _self;
  }

  const QuickSnack._internal();

  /// Clear the current snack
  void clear(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  void error(BuildContext context, String message) {
    if (message == null) {
      message = 'Unknown error occured';
      Log.e(
          'QuickSnack().error called with null message ${StackTraceImpl().formatStackTrace()}');
    }
    Flushbar bar;
    bar = Flushbar<void>(
        onStatusChanged: (status) => track(status, bar),
        flushbarPosition: FlushbarPosition.TOP,
        leftBarIndicatorColor: Colors.red,
        icon: Icon(Icons.warning, size: 32, color: Colors.red),
        message: message,
        duration: Duration(seconds: 20),
        mainButton: TextButton(
          child: Text('Close'),
          onPressed: () => bar.dismiss(),
        ))
      ..show(context);

    showing.add(bar);
  }

  /// [duration] controls how long the info message is displayed.
  /// If you don't pass the duration we calculate the duration based on the
  /// no. of words in the message.
  void info(BuildContext context, String message, {Duration duration}) {
    duration ??= Duration(seconds: ((message.length / 5.0) ~/ 3.0) + 1);
    Flushbar bar;
    bar = Flushbar<void>(
        onStatusChanged: (status) => track(status, bar),
        flushbarPosition: FlushbarPosition.TOP,
        title: 'Info',
        message: message,
        duration: duration,
        icon: Icon(Icons.info_outline, size: 32, color: Colors.blue.shade300),
        leftBarIndicatorColor: Colors.blue.shade300,
        mainButton: TextButton(
          child: Text('Close'),
          onPressed: () => bar.dismiss(),
        ))
      ..show(context);
    showing.add(bar);
  }

  void warning(BuildContext context, String message) {
    Flushbar bar;
    var duration = ((message.length / 5.0) ~/ 3.0) + 1;
    bar = Flushbar<void>(
        onStatusChanged: (status) => track(status, bar),
        flushbarPosition: FlushbarPosition.TOP,
        leftBarIndicatorColor: NJColors.errorBackground,
        duration: Duration(seconds: duration),
        icon: Icon(Icons.warning, size: 32, color: NJColors.errorBackground),
        message: message,
        mainButton: TextButton(
          child: Text('Close'),
          onPressed: () => bar.dismiss(),
        ))
      ..show(context);
    showing.add(bar);
  }

  void undo(
      {BuildContext context,
      Duration duration,
      String message,
      VoidCallback callback,
      String buttonText = 'Undo'}) {
    _undoBar?.dismiss();
    final Color color = Colors.amberAccent;
    final controller =
        AnimationController(vsync: LocalTickerProvider(), duration: duration);
    _undoBar = Flushbar<void>(
      flushbarPosition: FlushbarPosition.BOTTOM,
      duration: duration,
      icon: Icon(Icons.delete, color: color),
      // https://github.com/AndreHaueisen/flushbar/issues/110
      // bug in flushbar 1.10 so had to revert back to flusbar 1.6 margin: MediaQuery.of(context).padding,
      shouldIconPulse: false,
      showProgressIndicator: true,
      progressIndicatorValueColor: AlwaysStoppedAnimation<Color>(color),
      progressIndicatorController: controller,
      message: message,
      flushbarStyle: FlushbarStyle.FLOATING,
      mainButton: TextButton(
        child: Text(buttonText),
        onPressed: () {
          _undoBar.dismiss();
          callback();
        },
      ),
    )..show(context);
    controller.forward();
  }

  /*
  static void undo(
    BuildContext context,
    Duration duration,
    String message,
    VoidCallback callback,
  ) {
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBarEx(
      content: Text(message),
    ));
  }
  */

  void showSnack(BuildContext context, SnackBar snackBar,
      {bool removeCurrentSnackBar = false}) {
    if (removeCurrentSnackBar) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
