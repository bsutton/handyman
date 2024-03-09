import 'package:flutter/foundation.dart';
import '../../../../../app/router.dart';
import '../../../../../dialogs/dialog_question.dart';
import '../../../../../util/ansi_color.dart';
import '../../../../../util/log.dart';
import 'retry_overlay_data.dart';

class RetryOverlay {
  static const RetryOverlay _self = RetryOverlay._internal();
  static final List<RetryOverlayData> _outstanding = [];
  static const _MAX_OUTSTANDING = 10;

  static bool _mock = false;

  const RetryOverlay._internal();

  factory RetryOverlay(RetryOverlayData retryWorker) {
    if (_outstanding.length >= _MAX_OUTSTANDING) {
      _outstanding.removeAt(0).abortCallback();
    }
    _outstanding.add(retryWorker);

    Log.w(blue('added worker:  ${_outstanding.length} workers'));
    if (_outstanding.length == 1) {
      _self.show();
    }

    return _self;
  }

  @visibleForTesting
  static void mock() {
    _mock = true;
  }

  void show() {
    if (_mock) {
      var retryWorker = _outstanding[0];
      Log.w('${retryWorker.getUserMessage()}');
      retryOutstanding(cancel: false);
    } else {
      _show();
    }
  }

  void _show() {
    // We need to use an overlay as the RetryOverlay doesn't have direct access
    // to a context as it called off the back of a failed network request.
    var overlayState = SQRouter.navigatorKey.currentState.overlay;

    var retryWorker = _outstanding[0];

    var context = overlayState.context;
    if (context != null) {
      var result = DialogQuestion.show(
        context,
        'Alert',
        retryWorker.getUserMessage(),
        yesLabel: 'Retry',
        noLabel: retryWorker.showAbort() ? 'Cancel' : null,
      );
      result.then((answer) {
        Log.w(blue('Answering ${_outstanding.length} workers'));
        retryOutstanding(cancel: answer == DialogQuestionResult.NO);
        // visible = false;
      });
    } else {
      Log.w(blue('Unable to display retry as no context'));
    }
  }

  void _retry(RetryOverlayData retryOverlayData) {
    try {
      retryOverlayData.retryCallback();
    }
    // ignore: avoid_catches_without_on_clauses
    catch (e) {
      Log.e(e.toString());
    }
  }

  void _cancel(RetryOverlayData worker) {
    try {
      worker.abortCallback();
    }
    // ignore: avoid_catches_without_on_clauses
    catch (e) {
      Log.e(e.toString());
    }
  }

  void retryOutstanding({bool cancel}) {
    if (cancel) {
      for (var worker in _outstanding) {
        _cancel(worker);
      }
    } else {
      for (var worker in _outstanding) {
        _retry(worker);
      }
    }
    _outstanding.clear();
    Log.w(blue('Cleared list:  ${_outstanding.length} workers'));
  }
}
