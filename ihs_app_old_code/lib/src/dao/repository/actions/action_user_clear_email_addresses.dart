import 'dart:convert';

import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import 'action.dart';

class ActionUserClearEmailAddress extends Action<bool> {
  ActionUserClearEmailAddress(this.emailAddress, RetryData retryData)
      : super(retryData);
  final String emailAddress;

  @override
  bool decodeResponse(ActionResponse data) => data.wasSuccessful();

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'userClearEmailAddress';
    map[Action.mutatesKey] = causesMutation;
    map['emailAddress'] = emailAddress;

    return json.encode(map);
  }

  @override
  bool get causesMutation => false;

  @override
  List<Object> get props => [emailAddress];
}
