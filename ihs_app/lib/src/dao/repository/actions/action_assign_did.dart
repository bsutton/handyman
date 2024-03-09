import 'dart:convert';
import '../../../entities/entity.dart';
import '../../../entities/region.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/phone_number.dart';
import '../repository.dart';
import 'action.dart';

class ActionAssignTrialDID extends Action<AssignTrialDIDResponse> {
  final Repository repository;

  final GUID progressUUID;
  final GUID registrationUUID;
  final Region region;

  ActionAssignTrialDID(this.region, this.progressUUID, this.registrationUUID, this.repository, RetryData retryData)
      : super(retryData);

  @override
  AssignTrialDIDResponse decodeResponse(ActionResponse data) {
    return AssignTrialDIDResponse.fromJson(data);
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'assignDid';
    map[Action.MUTATES] = causesMutation;
    map[Action.ENTITY_TYPE] = region.runtimeType.toString();
    map[Action.ENTITY] = region.toJson();
    map[Action.PROGRESS_UUID] = progressUUID.toString();
    map['REGISTRATION_UUID'] = registrationUUID.toString();

    return json.encode(map);
  }

  @override
  List<Object> get props => [region, progressUUID, registrationUUID];

  @override
  bool get causesMutation => true;
}

class AssignTrialDIDResponse {
  bool success;
  PhoneNumber number;

  String failureCause;

  AssignTrialDIDResponse({this.success, this.number});

  AssignTrialDIDResponse.fromJson(ActionResponse response) {
    success = response.wasSuccessful();
    failureCause = response.userExceptionMessage;
    if (failureCause == null || failureCause.isEmpty) {
      number = PhoneNumber(response.data['number'] as String);
    }
  }
}
