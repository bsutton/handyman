import 'dart:convert';
import '../../../entities/team.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import 'action.dart';

class ActionTeamUpdateMembers extends Action<bool> {
  final Team team;

  ActionTeamUpdateMembers(this.team, RetryData retryData) : super(retryData);

  @override
  bool decodeResponse(ActionResponse data) {
    return data.wasSuccessful();
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'teamUpdateMembers';
    map[Action.MUTATES] = causesMutation;
    map['teamguid'] = team.guid;
    map['members'] = team.members;

    return json.encode(map);
  }

  @override
  bool get causesMutation => false;

  @override
  List<Object> get props => [team];
}
