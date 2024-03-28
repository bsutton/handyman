import 'package:flutter/foundation.dart';

import '../../../../app/router.dart';
import '../../../../dialogs/dialog_question.dart';
import '../../../../util/ansi_color.dart';
import '../../../../util/log.dart';
import 'retry_overlay_data.dart';

class RetryOverlay {
  factory RetryOverlay(RetryOverlayData retryWorker) {
    if (_outstanding.length >= _maxOutstanding) {
      _outstanding.removeAt(0).abortCallback();
    }
    _outstanding.add(retryWorker);

    Log.w(blue('added worker:  ${_outstanding.length} workers'));

    return _self;
  }

  const RetryOverlay._internal();
  static const RetryOverlay _self = RetryOverlay._internal();
  static final List<RetryOverlayData> _outstanding = [];
  static const _maxOutstanding = 10;

  static bool _mock = false;

  @visibleForTesting
  static void mock() {
    _mock = true;
  }

  Future<void> show() async {
    if (_outstanding.isEmpty) {
      return;
    }

    if (_mock) {
      final retryWorker = _outstanding[0];
      Log.w('${retryWorker.getUserMessage()}');
      retryOutstanding();
    } else {
      await _show();
    }
  }

  Future<void> _show() async {
    // We need to use an overlay as the RetryOverlay doesn't have direct access
    // to a context as it called off the back of a failed network request.
    final overlayState = SQRouter.navigatorKey.currentState!.overlay;

    final retryWorker = _outstanding[0];

    final context = overlayState!.context;
    final answer = await DialogQuestion.show(
      context,
      'Alert',
      retryWorker.getUserMessage() ?? 'Something unexpected happened',
      yesLabel: 'Retry',
      noLabel: retryWorker.showAbort() ? 'Cancel' : '',
    );
    Log.w(blue('Answering ${_outstanding.length} workers'));
    retryOutstanding(cancel: answer == DialogQuestionResult.no);
    // visible = false;
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

  void retryOutstanding({bool cancel = false}) {
    if (cancel) {
      for (final worker in _outstanding) {
        _cancel(worker);
      }
    } else {
      for (final worker in _outstanding) {
        _retry(worker);
      }
    }
    _outstanding.clear();
    Log.w(blue('Cleared list:  ${_outstanding.length} workers'));
  }
}
