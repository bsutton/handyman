import 'dart:convert';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import 'action.dart';

class ActionUserClearEmailAddress extends Action<bool> {
  final String emailAddress;

  ActionUserClearEmailAddress(this.emailAddress, RetryData retryData) : super(retryData);

  @override
  bool decodeResponse(ActionResponse data) {
    return data.wasSuccessful();
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'userClearEmailAddress';
    map[Action.MUTATES] = causesMutation;
    map['emailAddress'] = emailAddress;

    return json.encode(map);
  }

  @override
  bool get causesMutation => false;

  @override
  List<Object> get props => [emailAddress];
}
