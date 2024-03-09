import 'package:json_annotation/json_annotation.dart';

import '../types/er.dart';
import 'contact.dart';
import 'entity.dart';

part 'participant.g.dart';

enum ParticipantType { HOST, PRESENTER, PLEB }

@JsonSerializable()
class Participant extends Entity<Participant> {
  ParticipantType type;

  @ERCallerDetailsConverter()
  ER<Contact> contact;

  Participant();

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
}
