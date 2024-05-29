import 'dart:async';

import 'package:completer_ex/completer_ex.dart';
import 'package:faker/faker.dart';

import '../../../../util/log.dart';
import '../api_error.dart';
import 'retry_data.dart';
import 'retry_overlay.dart';
import 'retry_overlay_data.dart';

class RetryHelper<T> implements RetryOverlayData {
  RetryHelper._internal(this.call, this.retryData);
  Future<T> Function() call;
  RetryData retryData;
  dynamic error;
  int errorCount = 0;
  CompleterEx<T> completer = CompleterEx<T>();

  static Future<J> exec<J>(Future<J> Function() call, RetryData retryData) =>
      RetryHelper<J>._internal(call, retryData).run();

  Future<T> run() {
    try {
      call().then((response) {
        completer.complete(response);
      }).catchError((dynamic e) {
        Log.e(e.toString());
        handleError(e);
      });
    }
    // ignore: avoid_catches_without_on_clauses
    catch (e, s) {
      Log.e(e.toString(), stackTrace: s);
      handleError(e);
    }

    return completer.future;
  }

  Future<void> handleError(dynamic e) async {
    errorCount++;
    error = e;

    var option = retryData.option;
    if (error is ApiError) {
      if ((error as ApiError).generatedBy == 'RateLimitException') {
        option = RetryOption.WITH_BACK_OFF;
      }
    }
    if (option == RetryOption.USER) {
      await RetryOverlay(this).show();
    } else if (option == RetryOption.USER_RETRY_ONLY) {
      await RetryOverlay(this).show();
    } else if (option == RetryOption.WITH_BACK_OFF && errorCount < 10) {
      final delay = errorCount + RandomGenerator().integer(5, min: 1);
      Log.w('Retry in $delay seconds');
      await Future<void>.delayed(Duration(seconds: delay));
      await run();
    } else if (option == RetryOption.ONCE && errorCount < 2) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await run();
    } else {
      completer.completeError(e as Object);
    }
  }

  @override
  void abortCallback() {
    completer.completeError(error as Object);
  }

  @override
  bool showAbort() => retryData.option != RetryOption.USER_RETRY_ONLY;

  @override
  String? getUserMessage() => retryData.userMessage;

  @override
  Future<void> retryCallback() async {
    await run();
  }
}
