import 'package:json_annotation/json_annotation.dart';

import '../../util/local_date.dart';
import '../../util/local_time.dart';
import '../types/er.dart';
import 'activity.dart';
import 'attachment.dart';
import 'entity.dart';
import 'job.dart';

part 'task.g.dart';

enum TaskStatus { toBeScheduled, scheduled, inProgress, paused, completed }

/// Each job can have multiple tasks
@JsonSerializable()
class Task extends Entity<Task> {
  Task();

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

  @LocalTimeConverter()
  LocalTime? startTime;

  LocalDate? getStart() => startDate;

  @ERConverterActivity()
  List<ER<Activity>> activities = [];

  @ERConverterAttachment()
  late List<ER<Attachment>> attachments = [];

  @override
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
