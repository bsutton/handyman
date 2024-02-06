import 'dart:convert';
import '../../../bus/bus.dart';
import '../../../entities/team.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/er.dart';
import '../team_repository.dart';
import 'action.dart';

class ActionTeamCreate extends Action<ER<Team>> {
  final Team team;

  ActionTeamCreate(this.team, [RetryData retryData]) : super(RetryData.defaultRetry) {
    if (team.guid == null) {
      throw ArgumentError('guid must not be null');
    }
  }

  @override
  bool get causesMutation => true;

  @override
  ER<Team> decodeResponse(ActionResponse response) {
    Bus().add<Team>(BusAction.insert, instance: team);

    return ER(TeamRepository().fromJson(response.singleEntity));
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'teamCreate';
    map[Action.MUTATES] = causesMutation;
    map[Action.ENTITY_TYPE] = 'team';
    map[Action.ENTITY] = team;
    return json.encode(map);
  }

  @override
  List<Object> get props => null;
}
