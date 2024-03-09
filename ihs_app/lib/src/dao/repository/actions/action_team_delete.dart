import 'dart:convert';
import '../../../bus/bus.dart';
import '../../../entities/team.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import 'action.dart';

class ActionTeamDelete extends Action<bool> {
  final Team team;

  ActionTeamDelete(this.team) : super(RetryData.defaultRetry);

  @override
  bool get causesMutation => true;

  @override
  bool decodeResponse(ActionResponse data) {
    Bus().add<Team>(BusAction.delete, instance: team);
    return data.wasSuccessful();
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'teamDelete';
    map[Action.ENTITY_TYPE] = 'team';
    map[Action.MUTATES] = causesMutation;
    map[Action.GUID] = team.guid;
    return json.encode(map);
  }

  @override
  List<Object> get props => null;
}
