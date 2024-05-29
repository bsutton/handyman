import 'dart:convert';

import '../../entities/entity.dart';
import '../../entities/user_invitation.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/email_address.dart';
import '../../types/firebase_user_uid.dart';
import '../../types/phone_number.dart';
import '../repository.dart';
import 'action.dart';
import 'action_activate_invitation.dart';

/// Used to activate the first user of an organisation.
/// Additional users are activate via the [ActionActivateInvitation]
/// process.
class ActionRecoverLastManager<E extends Entity<E>>
    extends Action<UserInvitation> {
  ActionRecoverLastManager(
      this.firebaseTempUserUid,
      this.userInvite,
      this.mobileNumber,
      this.emailAddress,
      this.repository,
      RetryData retryData)
      : super(retryData);
  final FirebaseTempUserUid firebaseTempUserUid;
  final UserInvitation userInvite;
  final PhoneNumber? mobileNumber;
  final EmailAddress? emailAddress;
  final Repository<E> repository;

  @override
  UserInvitation decodeResponse(ActionResponse data) =>
      UserInvitation.fromJson(data.singleEntity!);

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'recoverLastManager';
    map[Action.entityTypeKey] = 'UserInvitation';
    map[Action.entityKey] = userInvite.toJson();
    map[Action.mutatesKey] = causesMutation;
    map[Action.firebaseTempUserUidKey] = firebaseTempUserUid;
    map[Action.mobileNumberKey] = mobileNumber.toString();
    map['emailAddress'] = emailAddress.toString();

    return json.encode(map);
  }

  @override
  List<Object> get props =>
      [FirebaseTempUserUid, mobileNumber ?? '', emailAddress ?? ''];

  @override
  bool get causesMutation => true;
}
