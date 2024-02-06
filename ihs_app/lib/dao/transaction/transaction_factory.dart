import '../repository/actions/action.dart';
import 'transaction.dart';

class TransactionFactory {
  factory TransactionFactory() => _self;

  const TransactionFactory._internal();
  static const TransactionFactory _self = TransactionFactory._internal();
  static Transaction? _transaction;

  static Transaction getActiveTransaction() {
    if (_transaction == null || _transaction!.sent) {
      _transaction = Transaction(autoCommit: true);
    }
    return _transaction!;
  }

  /// This method is a short cut to calling
  /// [TransactionFactory.getActiveTransaction().addAction(action)]
  static Future<R> addAction<R>(Action<R> action) {
    getActiveTransaction().addAction<R>(action);

    return action.future;
  }

  static Future<void> commit() async {
    if (_transaction != null) {
      await _transaction!.commit();
      _transaction = null;
    }
  }
}
