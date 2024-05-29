import 'package:flutter/widgets.dart' as flutter;

import '../../util/log.dart';
import 'transaction.dart';

///
/// This class is responsibe for auto commiting
/// Transactions that are marked as auto commit.
///
/// Normally it will attach the auto commit to Flutter
/// frame rendering cycle and perform an auto commit when the current
/// frame commits.
///
/// There are two problems that this class deals with:
/// 1) at certain times there is no frame in progress and no
/// frame scheduled. In this case the manager will wait
/// 500ms and then force an auto commit.
///
/// 2) when unit testing there may be no flutter
/// and as such we can hook the flutter 'frame's.
/// In this case call  'disableFrames' to
/// stop the manager from trying to use flutters post frame
/// handling.
///
class AutoCommitManager {
  factory AutoCommitManager() => _self;

  const AutoCommitManager._internal();
  static const AutoCommitManager _self = AutoCommitManager._internal();

  static bool _disableFrames = false;

  // Intended for use by unit tests.
  // call this method to allow autocommit transactions to
  // still work when unit testing.
  void disableFrames() {
    _disableFrames = true;
  }

  void scheduleCommit(Transaction transaction) {
    // choose the primary mechanism.
    if (_disableFrames) {
      Future<void>.delayed(
          const Duration(milliseconds: 200), () async => _commit(transaction));
    } else {
      flutter.WidgetsBinding.instance
          .addPostFrameCallback((_) async => _commit(transaction));

      // sometimes no frame needs to be draw so we need to force an autocommit
      Future.delayed(const Duration(milliseconds: 500), () async {
        if (!transaction.sent) {
          Log().w('AutoCommit transaction was fired via a delay');
          await _commit(transaction);
        }
      });
    }
  }

  Future<void> _commit(Transaction transaction) async {
    if (!transaction.sent) {
      await transaction.commit();
    }
  }
}
