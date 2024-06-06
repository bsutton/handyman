import '../entity/task_status.dart';
import 'dao.dart';

class DaoTaskStatus extends Dao<TaskStatus> {
  @override
  String get tableName => 'task_status';

  @override
  TaskStatus fromMap(Map<String, dynamic> map) => TaskStatus.fromMap(map);
}
