import 'dart:convert';
import 'package:squarephone/src/dao/repository/actions/action_activate_invitation.dart';

import '../../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/phone_number.dart';
import '../repository.dart';
import 'action.dart';

/// Used to activate the first user of an organisation.
/// Additional users are activate via the [ActionActivateInvitation]
/// process.
class ActionActivateFirstUser<E extends Entity<E>> extends Action<FirstUserDetails> {
  final GUID progressUUID;
  final PhoneNumber mobileNumber;
  final Repository<E> repository;
  ActionActivateFirstUser(this.progressUUID, this.mobileNumber, this.repository, RetryData retryData)
      : super(retryData);

  @override
  FirstUserDetails decodeResponse(ActionResponse response) {
    var details = FirstUserDetails.fromJson(response);
    return details;
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'activateFirstUser';
    map[Action.MUTATES] = causesMutation;
    map[Action.PROGRESS_UUID] = progressUUID.toString();
    map[Action.MOBILE_NUMBER] = mobileNumber.toString();

    return json.encode(map);
  }

  @override
  List<Object> get props => [progressUUID, mobileNumber];

  @override
  bool get causesMutation => true;
}

class FirstUserDetails {
  bool success;
  String apiKey;
  String fireStoreUserToken;
  String registrationGUID;
  String userGUID;
  String failureMessage;

  FirstUserDetails({this.success, this.apiKey});

  FirstUserDetails.fromJson(ActionResponse response) {
    success = response.success;
    apiKey = response.data['apiKey'] as String;
    fireStoreUserToken = response.data['fireStoreUserToken'] as String;
    registrationGUID = response.data['registrationGUID'] as String;
    userGUID = response.data['userGUID'] as String;
    failureMessage = response.exception;
  }
}
