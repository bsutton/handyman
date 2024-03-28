import '../entities/activity.dart';
import '../entities/job.dart';
import 'repository.dart';

class ActivityRepository extends Repository<Activity> {
  ActivityRepository() : super(const Duration(seconds: 5));

  Future<List<Activity>> getByJob(Job job) async =>
      getList('guid', job.guid.toString());

  @override
  Activity fromJson(Map<String, dynamic> json) => Activity.fromJson(json);
}
