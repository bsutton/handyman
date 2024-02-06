import 'dart:convert';
import '../../../entities/entity.dart';
import '../../../entities/user_invitation.dart';
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
class ActionUserInvitationByMobile<E extends Entity<E>> extends Action<UserInvitation> {
  final PhoneNumber mobileNumber;
  final Repository<E> repository;
  ActionUserInvitationByMobile(this.mobileNumber, this.repository, RetryData retryData) : super(retryData);

  @override
  UserInvitation decodeResponse(ActionResponse response) {
    var invite = UserInvitation.fromJson(response.singleEntity);
    return invite;
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};

    map[Action.ENTITY_TYPE] = 'UserInvite';
    map[Action.ACTION] = 'userInvitationByMobile';
    map[Action.MUTATES] = causesMutation;
    map[Action.MOBILE_NUMBER] = mobileNumber.toString();

    return json.encode(map);
  }

  @override
  List<Object> get props => [mobileNumber];

  @override
  bool get causesMutation => true;
}
