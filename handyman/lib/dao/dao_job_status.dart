import '../entity/job_status.dart';
import 'dao.dart';

class DaoJobStatus extends Dao<JobStatus> {
  @override
  String get tableName => 'job_status';

  @override
  JobStatus fromMap(Map<String, dynamic> map) => JobStatus.fromMap(map);
}
