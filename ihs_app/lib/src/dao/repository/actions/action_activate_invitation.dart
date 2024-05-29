import 'dart:convert';

import '../../../util/enum_helper.dart';
import '../../entities/entity.dart';
import '../../entities/user_invitation.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/firebase_user_uid.dart';
import '../repository.dart';
import 'action.dart';
import 'action_activate_first_user.dart';

/// Used to activate invitations to join an organisation.
/// This could be new users or existing users.
/// The very first user must be activated via the [ActionActivateFirstUser]
/// process.
class ActionActivateInvitation<E extends Entity<E>>
    extends Action<InvitationDetails> {
  ActionActivateInvitation(this.firebaseTempUserUid, this.inviteGUID,
      this.repository, RetryData retryData)
      : super(retryData);
  final FirebaseTempUserUid firebaseTempUserUid;
  final GUID inviteGUID;
  final Repository<E> repository;

  @override
  InvitationDetails decodeResponse(ActionResponse data) {
    final details = InvitationDetails.fromJson(data)
      ..firebaseTempUserUid = firebaseTempUserUid;
    return details;
  }

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'actionActivateInvitation';
    map[Action.mutatesKey] = causesMutation;
    map[Action.guidKey] = inviteGUID.toString();

    return json.encode(map);
  }

  @override
  List<Object> get props => [firebaseTempUserUid, inviteGUID];

  @override
  bool get causesMutation => true;
}

class InvitationDetails {
  InvitationDetails({this.success = true, this.apiKey});

  InvitationDetails.fromJson(ActionResponse response) {
    type = EnumHelper.getEnum(
        response.data!['invitationType'] as String, InvitationType.values);

    state = EnumHelper.getEnum(
        response.data!['invitationState'] as String, InvitationState.values);
    apiKey = response.data!['apiKey'] as String;
    fireStoreUserToken = response.data!['fireStoreUserToken'] as String;
    userGUID = response.data!['userGUID'] as String;
    exception = response.exception;
  }
  bool success = true;
  late InvitationType type;
  late InvitationState state;
  String? apiKey;
  late FirebaseTempUserUid firebaseTempUserUid;
  late String fireStoreUserToken;
  late String userGUID;
  String? exception;
}
