import 'dart:convert';

import '../../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

/// Used when a user is attempting to recover their account.
/// We have validated their email address
class ActionIsEmailVerificationComplete<E extends Entity<E>> extends Action<bool> {
  final GUID verificationGUID;
  final Repository<E> repository;
  ActionIsEmailVerificationComplete(this.verificationGUID, this.repository, RetryData retryData) : super(retryData);

  @override
  bool decodeResponse(ActionResponse data) {
    return data.data[Action.BOOL] as bool;
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'isEmailVerificationComplete';
    map[Action.MUTATES] = causesMutation;
    map[Action.GUID] = verificationGUID;

    return json.encode(map);
  }

  @override
  List<Object> get props => [verificationGUID];

  @override
  bool get causesMutation => false;
}
