import 'package:json_annotation/json_annotation.dart';
import '../types/er.dart';
import 'entity.dart';
import 'participant.dart';
import 'user.dart';

part 'Job.g.dart';


@JsonSerializable()
class Job extends Entity<Job> {
  @ERUserConverter()
  ER<User> createdBy;

  // the user that the Job is assigned to.
  @ERUserConverter()
  ER<User> assignedTo;

  String name;
  String description;
  DateTime startTime;
  DateTime earlyCheckinTime;
  Duration estimatedDuration;

  WhoSpeaks whoSpeaks;

  @ERParticipantConverter()
  List<ER<Participant>> participants;

  Job();

  factory Job.fromJson(Map<String, dynamic> json) =>
      _$JobFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$JobToJson(this);
}
