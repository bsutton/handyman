class CancelableFuture {
  CancelableFuture(Duration duration, void Function() callback) {
    Future<void>.delayed(duration, () {
      if (!cancelled) {
        callback();
      }
    });
  }
  bool cancelled = false;

  void cancel() {
    cancelled = true;
  }
}
