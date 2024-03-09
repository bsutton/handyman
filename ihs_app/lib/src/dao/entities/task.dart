import 'package:json_annotation/json_annotation.dart';

import '../../util/format.dart';
import '../../util/local_date.dart';
import '../../util/local_time.dart';
import '../types/er.dart';
import 'check_list_item_type.dart';
import 'entity.dart';
import 'user.dart';

part 'task.g.dart';

enum TaskStatus { toBeScheduled, scheduled, inProgress, paused, completed }

/// Each job can have multiple tasks
@JsonSerializable()
class Task extends Entity<Task> {
  Task(this.job);

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  // The job that this task is associated with.
  @ERConverterJob()
  late ER<Job> job;

  late String name;

  late String description;

  TaskStatus status = TaskStatus.toBeScheduled;

  // The first day that the user is on leave
  @LocalDateConverter()
  LocalDate? startDate;
  LocalTime? startTime;

  LocalDate? getStart() => startDate;

  @override
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
