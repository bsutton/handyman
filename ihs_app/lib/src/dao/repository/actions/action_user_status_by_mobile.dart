import 'dart:convert';

import '../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/firebase_user_uid.dart';
import '../../types/phone_number.dart';
import '../repository.dart';
import 'action.dart';
import 'user_status_details.dart';

/// Used when a user is attempting to recover their account.
/// We have validated their mobile number (as proved vy the 
/// [FirebaseTempUserUid])
/// and we now need to find their user details.
/// This may fail if the user has changed their mobile no.
class ActionUserStatusByMobile<E extends Entity<E>>
    extends Action<UserStatusDetails> {
  ActionUserStatusByMobile(this.firebaseTempUserUid, this.mobileNumber,
      this.repository, RetryData retryData)
      : super(retryData);
  final FirebaseTempUserUid firebaseTempUserUid;
  final PhoneNumber mobileNumber;
  final Repository<E> repository;

  @override
  UserStatusDetails decodeResponse(ActionResponse data) {
    final user = UserStatusDetails.fromJson(data);
    return user;
  }

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'userStatusByMobile';
    map[Action.entityTypeKey] = 'UserInvitation';
    map[Action.mutatesKey] = causesMutation;
    map[Action.mobileNumberKey] = mobileNumber.toString();

    return json.encode(map);
  }

  @override
  List<Object> get props => [FirebaseTempUserUid, mobileNumber];

  @override
  bool get causesMutation => true;
}
