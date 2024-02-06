import 'dart:convert';

import 'package:squarephone/src/dao/repository/actions/action_activate_first_user.dart';

import '../../../../registration_wizard/invitation_state.dart';
import '../../../../util/enum_helper.dart';
import '../../../entities/entity.dart';
import '../../../entities/user_invitation.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/firebase_user_uid.dart';
import '../repository.dart';
import 'action.dart';

/// Used to activate invitations to join an organisation.
/// This could be new users or existing users.
/// The very first user must be activated via the [ActionActivateFirstUser]
/// process.
class ActionActivateInvitation<E extends Entity<E>>
    extends Action<InvitationDetails> {
  final FirebaseTempUserUid firebaseTempUserUid;
  final GUID inviteGUID;
  final Repository<E> repository;
  ActionActivateInvitation(this.firebaseTempUserUid, this.inviteGUID,
      this.repository, RetryData retryData)
      : super(retryData);

  @override
  InvitationDetails decodeResponse(ActionResponse response) {
    var details = InvitationDetails.fromJson(response);
    details.firebaseTempUserUid = firebaseTempUserUid;
    return details;
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'actionActivateInvitation';
    map[Action.MUTATES] = causesMutation;
    map[Action.GUID] = inviteGUID.toString();

    return json.encode(map);
  }

  @override
  List<Object> get props => [firebaseTempUserUid, inviteGUID];

  @override
  bool get causesMutation => true;
}

class InvitationDetails {
  bool success;
  InvitationType type;
  InvitationState state;
  String apiKey;
  FirebaseTempUserUid firebaseTempUserUid;
  String fireStoreUserToken;
  String userGUID;
  String exception;

  InvitationDetails({this.success, this.apiKey});

  InvitationDetails.fromJson(ActionResponse response) {
    type = EnumHelper.getEnum(
        response.data['invitationType'] as String, InvitationType.values);

    state = EnumHelper.getEnum(
        response.data['invitationState'] as String, InvitationState.values);
    apiKey = response.data['apiKey'] as String;
    fireStoreUserToken = response.data['fireStoreUserToken'] as String;
    userGUID = response.data['userGUID'] as String;
    exception = response.exception;
  }
}
