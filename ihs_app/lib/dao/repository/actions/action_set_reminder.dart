import 'dart:convert';
import '../../../entities/mobile_registration_reminder.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

class ActionSetReminder extends Action<SetReminderResponse> {
  final Repository repository;

  final MobileRegistrationReminder reminder;

  ActionSetReminder(this.reminder, this.repository, RetryData retryData) : super(retryData);

  @override
  SetReminderResponse decodeResponse(ActionResponse data) {
    return SetReminderResponse.fromJson(data);
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'setReminder';
    map[Action.MUTATES] = causesMutation;
    map[Action.ENTITY_TYPE] = reminder.runtimeType.toString();
    map[Action.ENTITY] = reminder.toJson();

    return json.encode(map);
  }

  @override
  List<Object> get props => [reminder];

  @override
  bool get causesMutation => true;
}

class SetReminderResponse {
  bool success;

  String failureCause;

  SetReminderResponse({this.success});

  SetReminderResponse.fromJson(ActionResponse response) {
    success = response.wasSuccessful();
    failureCause = response.userExceptionMessage;
  }
}
