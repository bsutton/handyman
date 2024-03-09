abstract class RetryOverlayData {
  void abortCallback();
  void retryCallback();
  bool showAbort();
  String? getUserMessage();
}
