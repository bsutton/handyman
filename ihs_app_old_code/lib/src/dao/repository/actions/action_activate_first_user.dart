import 'dart:convert';

import '../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/phone_number.dart';
import '../repository.dart';
import 'action.dart';
import 'action_activate_invitation.dart';

/// Used to activate the first user of an organisation.
/// Additional users are activate via the [ActionActivateInvitation]
/// process.
class ActionActivateFirstUser<E extends Entity<E>>
    extends Action<FirstUserDetails> {
  ActionActivateFirstUser(this.progressUUID, this.mobileNumber, this.repository,
      RetryData retryData)
      : super(retryData);
  final GUID progressUUID;
  final PhoneNumber mobileNumber;
  final Repository<E> repository;

  @override
  FirstUserDetails decodeResponse(ActionResponse data) {
    final details = FirstUserDetails.fromJson(data);
    return details;
  }

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'activateFirstUser';
    map[Action.mutatesKey] = causesMutation;
    map[Action.processUuidKey] = progressUUID.toString();
    map[Action.mobileNumberKey] = mobileNumber.toString();

    return json.encode(map);
  }

  @override
  List<Object> get props => [progressUUID, mobileNumber];

  @override
  bool get causesMutation => true;
}

class FirstUserDetails {
  FirstUserDetails({this.success = true, this.apiKey});

  FirstUserDetails.fromJson(ActionResponse response) {
    success = response.success ?? false;
    apiKey = response.data!['apiKey'] as String;
    fireStoreUserToken = response.data!['fireStoreUserToken'] as String;
    registrationGUID = response.data!['registrationGUID'] as String;
    userGUID = response.data!['userGUID'] as String;
    failureMessage = response.exception ?? 'Success';
  }
  bool? success;
  String? apiKey;
  String? fireStoreUserToken;
  String? registrationGUID;
  String? userGUID;
  String? failureMessage;
}
