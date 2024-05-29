import 'dart:convert';

import '../../entities/entity.dart';
import '../../entities/user_invitation.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/firebase_user_uid.dart';
import '../repository.dart';
import 'action.dart';

/// Used when a user is attempting to recover their account.
/// We have validated their mobile number (as proved vy the 
/// [FirebaseTempUserUid])
/// we need to create a invitation incase the app restarts and
/// we need to recover.
class ActionCreateInvitation<E extends Entity<E>>
    extends Action<UserInvitation> {
  ActionCreateInvitation(
      this.userInviation, this.repository, RetryData retryData)
      : super(retryData);
  final UserInvitation userInviation;
  final Repository<E> repository;

  @override
  UserInvitation decodeResponse(ActionResponse data) {
    final invite = UserInvitation.fromJson(data.singleEntity!);
    return invite;
  }

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'createUserInvitation';
    map[Action.mutatesKey] = causesMutation;
    map[Action.entityTypeKey] = userInviation.runtimeType.toString();
    map[Action.entityKey] = userInviation;

    return json.encode(map);
  }

  @override
  List<Object> get props => [userInviation];

  @override
  bool get causesMutation => true;
}
