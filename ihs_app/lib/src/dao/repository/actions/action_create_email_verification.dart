import 'dart:convert';

import '../../entities/email_verification.dart';
import '../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

/// Used when a user is attempting to recover their account.
/// We have validated their email address
class ActionCreateEmailVerification<E extends Entity<E>>
    extends Action<EmailVerification> {
  ActionCreateEmailVerification(
      this.verification, this.repository, RetryData retryData)
      : super(retryData);
  final EmailVerification verification;
  final Repository<E> repository;

  @override
  EmailVerification decodeResponse(ActionResponse data) {
    final verification = EmailVerification.fromJson(data.singleEntity!);
    return verification;
  }

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'createEmailVerification';
    map[Action.mutatesKey] = causesMutation;
    map[Action.entityTypeKey] = verification.runtimeType.toString();
    map[Action.entityKey] = verification;

    return json.encode(map);
  }

  @override
  List<Object> get props => [verification];

  @override
  bool get causesMutation => true;
}
