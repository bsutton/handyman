import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../widgets/theme/nj_theme.dart';
import 'local_ticker_provider.dart';

/// A short cut to displaying a SnackBar.
///
/// ```dart
/// QuickSnack().error(context, "Something bad happend");
/// QuickSnack().info(context, "Did you know that...", duration: Duration(5))
/// QuickSnack().warn(context, "Look out");
/// QuickSnack().undo(context,   duration: Duration(5), 'Undo delete', () => something.undoit());
/// ```
class QuickSnack {
  factory QuickSnack() => _self;

  const QuickSnack._internal();
  static const QuickSnack _self = QuickSnack._internal();
  static late Flushbar<void> _undoBar;

  static final showing = <Flushbar<void>>[];

  /// Clear the current snack
  void clear(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  Future<void> error(BuildContext context, String message) async {
    late Flushbar<void> bar;
    bar = Flushbar<void>(
        onStatusChanged: (status) => track(status, bar),
        flushbarPosition: FlushbarPosition.TOP,
        leftBarIndicatorColor: Colors.red,
        icon: const Icon(Icons.warning, size: 32, color: Colors.red),
        message: message,
        duration: const Duration(seconds: 20),
        mainButton: TextButton(
          child: const Text('Close'),
          onPressed: () => bar.dismiss(),
        ));
    await bar.show(context);

    showing.add(bar);
  }

  /// [duration] controls how long the info message is displayed.
  /// If you don't pass the duration we calculate the duration based on the
  /// no. of words in the message.
  Future<void> info(BuildContext context, String message,
      {Duration? duration}) async {
    duration ??= Duration(seconds: ((message.length / 5.0) ~/ 3.0) + 1);
    late Flushbar<void> bar;
    bar = Flushbar<void>(
        onStatusChanged: (status) => track(status, bar),
        flushbarPosition: FlushbarPosition.TOP,
        title: 'Info',
        message: message,
        duration: duration,
        icon: Icon(Icons.info_outline, size: 32, color: Colors.blue.shade300),
        leftBarIndicatorColor: Colors.blue.shade300,
        mainButton: TextButton(
          child: const Text('Close'),
          onPressed: () async => bar.dismiss(),
        ));
    await bar.show(context);
    showing.add(bar);
  }

  Future<void> warning(BuildContext context, String message) async {
    late Flushbar<void> bar;
    final duration = ((message.length / 5.0) ~/ 3.0) + 1;
    bar = Flushbar<void>(
        onStatusChanged: (status) => track(status, bar),
        flushbarPosition: FlushbarPosition.TOP,
        leftBarIndicatorColor: NJColors.errorBackground,
        duration: Duration(seconds: duration),
        icon: const Icon(Icons.warning,
            size: 32, color: NJColors.errorBackground),
        message: message,
        mainButton: TextButton(
          child: const Text('Close'),
          onPressed: () async => bar.dismiss(),
        ));
    await bar.show(context);
    showing.add(bar);
  }

  Future<void> undo(
      {required BuildContext context,
      required Duration duration,
      required String message,
      VoidCallback? callback,
      String buttonText = 'Undo'}) async {
    await _undoBar.dismiss();
    const Color color = Colors.amberAccent;
    final controller =
        AnimationController(vsync: LocalTickerProvider(), duration: duration);
    _undoBar = Flushbar<void>(
      duration: duration,
      icon: const Icon(Icons.delete, color: color),
      // https://github.com/AndreHaueisen/flushbar/issues/110
      // bug in flushbar 1.10 so had to revert back to flusbar 1.6 margin: MediaQuery.of(context).padding,
      shouldIconPulse: false,
      showProgressIndicator: true,
      progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(color),
      progressIndicatorController: controller,
      message: message,
      mainButton: TextButton(
        child: Text(buttonText),
        onPressed: () {
          _undoBar.dismiss();
          callback?.call();
        },
      ),
    );
    if (context.mounted) {
      await _undoBar.show(context);
    }
    await controller.forward();
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

  // not certain what it is meant to do. - maybe something to do with the undo
  // handler.
  void track(FlushbarStatus? status, Flushbar<void> bar) {}
}
