import '../transaction/api/retry/retry_data.dart';
import '../transaction/transaction.dart';
import 'actions/action.dart';
import 'repository.dart';

/// Provides an entry point for running actions against the server
/// that do not related to a specific entity.
/// This could be for items such as running a task (e.g. send an email)
/// but essentialy any action that doesn't take or return an entity.
class NonEntityRepository {
  NonEntityRepository(); //: super(Duration(hours: 5));

  /// Use this to send a custom action that performs a task
  /// on the server and provides a response.
  /// The action results are not cached.
  /// This is intended for simple actions like sending an email.
  Future<R> taskAction<R>(Action<R> taskAction,
      {Transaction transaction, bool force = false, RetryData retryData = RetryData.defaultRetry}) {
    Repository.findTransaction(transaction).addAction<R>(taskAction);

    return taskAction.future;
  }
}
