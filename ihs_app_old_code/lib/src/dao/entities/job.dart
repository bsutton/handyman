import 'package:json_annotation/json_annotation.dart';

import '../types/er.dart';
import 'activity.dart';
import 'attachment.dart';
import 'contact_role.dart';
import 'customer.dart';
import 'entity.dart';
import 'organisation.dart';
import 'stage.dart';
import 'task.dart';

part 'job.g.dart';

@JsonSerializable()
class Job extends Entity<Job> {
  Job();

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  @ERConverterOrganisation()
  late ER<Organisation> owner;

  @ERConverterCustomer()
  late ER<Customer> customer;

  /// list of contacts associated with the job
  @ERConverterContactRole()
  late List<ER<ContactRole>> contacts = [];

  @ERConverterAttachment()
  late List<ER<Attachment>> attachments = [];

  @ERConverterStage()
  late ER<Stage> stage;

  // the user that the Job is assigned to.
  @ERConverterUser()
  late ER<User> assignedTo;

  late String name;
  late String description;
  late DateTime? startTime;

  @ERConverterTask()
  List<ER<Task>> tasks = [];

  @ERConverterActivity()
  List<ER<Activity>> activities = [];

  @override
  Map<String, dynamic> toJson() => _$JobToJson(this);
}
