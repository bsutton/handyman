import 'dart:async';

///
/// Schedules the given action for immediate execution
/// on the next microtask loop.
///
/// Useful for when you need to trigger an action during
/// a build that isn't permitted during a build cycle.
void scheduleNow(void Function() action) {
  Future<void>.delayed(Duration.zero, action);
}
