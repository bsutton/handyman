import 'dart:convert';

import '../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

/// Used when a user is attempting to recover their account.
/// We have validated their email address
class ActionIsEmailVerificationComplete<E extends Entity<E>>
    extends Action<bool> {
  ActionIsEmailVerificationComplete(
      this.verificationGUID, this.repository, RetryData retryData)
      : super(retryData);
  final GUID verificationGUID;
  final Repository<E> repository;

  @override
  bool decodeResponse(ActionResponse data) =>
      data.data![Action.boolKey] as bool;

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'isEmailVerificationComplete';
    map[Action.mutatesKey] = causesMutation;
    map[Action.guidKey] = verificationGUID;

    return json.encode(map);
  }

  @override
  List<Object> get props => [verificationGUID];

  @override
  bool get causesMutation => false;
}
