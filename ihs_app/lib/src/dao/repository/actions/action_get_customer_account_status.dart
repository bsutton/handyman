import 'dart:convert';

import '../../../util/customer_account_status.dart';
import '../../../util/enum_helper.dart';
import '../../entities/user.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

class ActionGetCustomerAccountStatus
    extends Action<CustomerAccountStatusResponse> {
  ActionGetCustomerAccountStatus(
      this.user, this.repository, RetryData retryData)
      : super(retryData);
  final Repository repository;

  final User user;

  @override
  CustomerAccountStatusResponse decodeResponse(ActionResponse data) =>
      CustomerAccountStatusResponse.fromJson(data);

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'customerAccountStatus';
    map[Action.mutatesKey] = causesMutation;

    return json.encode(map);
  }

  @override
  List<Object> get props => [user];

  @override
  bool get causesMutation => false;
}

class CustomerAccountStatusResponse {
  CustomerAccountStatusResponse({this.success});

  CustomerAccountStatusResponse.fromJson(ActionResponse response) {
    success = response.wasSuccessful();
    accountStatus = EnumHelper.getEnum(
        response.data!['status'] as String, CustomerAccountStatus.values);
    failureCause = response.userExceptionMessage;
  }
  bool? success;
  CustomerAccountStatus? accountStatus;

  String? failureCause;
}
