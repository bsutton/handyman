import 'dart:convert';

import '../../entities/entity.dart';
import '../../entities/user_invitation.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/firebase_user_uid.dart';
import '../../types/phone_number.dart';
import '../repository.dart';
import 'action.dart';

/// Used when a user is attempting to recover their account.
/// We have validated their mobile number (as proved vy the [FirebaseTempUserUid])
/// and we now need to find their user details.
/// This may fail if the user has changed their mobile no.
class ActionUserInvitationByMobile<E extends Entity<E>>
    extends Action<UserInvitation> {
  ActionUserInvitationByMobile(
      this.mobileNumber, this.repository, RetryData retryData)
      : super(retryData);
  final PhoneNumber mobileNumber;
  final Repository<E> repository;

  @override
  UserInvitation decodeResponse(ActionResponse data) {
    final invite = UserInvitation.fromJson(data.singleEntity!);
    return invite;
  }

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};

    map[Action.entityTypeKey] = 'UserInvite';
    map[Action.action] = 'userInvitationByMobile';
    map[Action.mutatesKey] = causesMutation;
    map[Action.mobileNumberKey] = mobileNumber.toString();

    return json.encode(map);
  }

  @override
  List<Object> get props => [mobileNumber];

  @override
  bool get causesMutation => true;
}
