import 'dart:convert';

import '../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/firebase_user_uid.dart';
import '../repository.dart';
import 'action.dart';
import 'user_status_details.dart';

/// Used when a user is attempting to recover their account.
/// We need to get their status  via their email address
///
/// This entry point has serious security implications as it could be used
/// obtain a list of all viable email address on our system.
/// We need to rate limit this call.
///
/// 10 invalid request per hour from a given mobile
/// 1 valid request per hour from a given mobile.
/// Max of 5 valid requests in a week.
///
/// and we now need to find their user details.
/// This may fail if the user has changed their mobile no.
class ActionUserStatusByEmail<E extends Entity<E>>
    extends Action<UserStatusDetails> {
  ActionUserStatusByEmail(this.firebaseTempUserUid, this.emailAddress,
      this.repository, RetryData retryData)
      : super(retryData);
  final FirebaseTempUserUid firebaseTempUserUid;
  final String emailAddress;
  final Repository<E> repository;

  @override
  UserStatusDetails decodeResponse(ActionResponse data) {
    final user = UserStatusDetails.fromJson(data);
    return user;
  }

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'userStatusByEmail';
    map[Action.entityTypeKey] = 'UserInvitation';
    map[Action.mutatesKey] = causesMutation;
    map[Action.emailAdderssKey] = emailAddress;

    return json.encode(map);
  }

  @override
  List<Object> get props => [FirebaseTempUserUid, emailAddress];

  @override
  bool get causesMutation => true;
}
