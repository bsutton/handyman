import 'package:json_annotation/json_annotation.dart';

import '../types/er.dart';
import 'entity.dart';
import 'participant.dart';
import 'user.dart';

part 'Job.g.dart';

@JsonSerializable()
class Job extends Entity<Job> {
  Job();

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  @ERConverterOrgansation()
  late ER<Organsation> owner;

  @ERConverterCustomer()
  late ER<Customer> customer;

  // the user that the Job is assigned to.
  @ERUserConverter()
  late ER<User> assignedTo;

  late String name;
  late String description;
  late DateTime? startTime;

  List<ER<Task>> tasks = [];

  @override
  Map<String, dynamic> toJson() => _$JobToJson(this);
}
