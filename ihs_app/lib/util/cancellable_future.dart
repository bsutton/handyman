class CancelableFuture {
  bool cancelled = false;
  CancelableFuture(Duration duration, void Function() callback) {
    Future<void>.delayed(duration, () {
      if (!cancelled) {
        callback();
      }
    });
  }

  void cancel() {
    cancelled = true;
  }
}
