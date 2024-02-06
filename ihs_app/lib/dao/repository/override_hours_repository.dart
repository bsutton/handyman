import '../../entities/override_hours.dart';
import '../../entities/team.dart';
import 'repository.dart';

class OverrideHoursRepository extends Repository<OverrideHours> {
  OverrideHoursRepository() : super(Duration(minutes: 5));

  Future<OverrideHours> getByTeam(Team team) async {
    return getFirst('team.guid', team.guid.toString());
  }

  @override
  OverrideHours fromJson(Map<String, dynamic> json) {
    return OverrideHours.fromJson(json);
  }
}
