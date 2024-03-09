import 'dart:convert';
import 'package:squarephone/src/dao/repository/actions/action_activate_invitation.dart';

import '../../../entities/entity.dart';
import '../../../entities/user_invitation.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/email_address.dart';
import '../../types/firebase_user_uid.dart';
import '../../types/phone_number.dart';
import '../repository.dart';
import 'action.dart';

/// Used to activate the first user of an organisation.
/// Additional users are activate via the [ActionActivateInvitation]
/// process.
class ActionRecoverLastManager<E extends Entity<E>>
    extends Action<UserInvitation> {
  final FirebaseTempUserUid firebaseTempUserUid;
  final UserInvitation userInvite;
  final PhoneNumber mobileNumber;
  final EmailAddress emailAddress;
  final Repository<E> repository;

  ActionRecoverLastManager(
      this.firebaseTempUserUid,
      this.userInvite,
      this.mobileNumber,
      this.emailAddress,
      this.repository,
      RetryData retryData)
      : super(retryData);

  @override
  UserInvitation decodeResponse(ActionResponse response) {
    return UserInvitation.fromJson(response.singleEntity);
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'recoverLastManager';
    map[Action.ENTITY_TYPE] = 'UserInvitation';
    map[Action.ENTITY] = userInvite.toJson();
    map[Action.MUTATES] = causesMutation;
    map[Action.FIREBASE_TEMP_USER_UID] = firebaseTempUserUid;
    map[Action.MOBILE_NUMBER] = mobileNumber.toString();
    map['emailAddress'] = emailAddress.toString();

    return json.encode(map);
  }

  @override
  List<Object> get props => [FirebaseTempUserUid, mobileNumber, emailAddress];

  @override
  bool get causesMutation => true;
}
