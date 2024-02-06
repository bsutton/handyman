import 'package:json_annotation/json_annotation.dart';

import '../enums/forward_calls_to.dart';
import '../repository/repos.dart';
import '../types/er.dart';
import '../types/phone_number.dart';
import 'audio_file.dart';
import 'customer.dart';
import 'entity.dart';
import 'ivr.dart';
import 'job.dart';
import 'team.dart';
import 'user.dart';

export '../enums/forward_calls_to.dart';
export 'audio_file.dart';
export 'ivr.dart';
export 'job.dart';
export 'team.dart';
export 'user.dart';

part 'call_forward_target.g.dart';

enum MessageMethod { GENERATED, RECORDED }

/// This class MUST only be a nested entity
@JsonSerializable()
class CallForwardTarget extends Entity<CallForwardTarget> {
  @ERCustomerConverter()
  ER<Customer> owner;

  ForwardCallsTo forwardCallsTo;

  @PhoneNumberConverter()
  PhoneNumber externalNo;

  MessageMethod messageMethod;

  // If ForwardCallsTo == VOICEMAIL or IVR and  [MessageMethod] == GENERATED
  @ERAudioFileConverter()
  ER<AudioFile> generated;

  // If ForwardCallsTo == VOICEMAIL and or IVR If [MessageMethod] is set to [RECORDED]
  // this will contain the recording.
  @ERAudioFileConverter()
  ER<AudioFile> recording;

  // if ForwardCallsTo == MESSAGE this will contain the message.
  @ERAudioFileConverter()
  ER<AudioFile> message;

  // if ForwardCallsTo == COLLEAGUE then this contains the colleague.
  @ERUserConverter()
  ER<User> colleague;

  // if  ForwardCallsTo == TEAM then this contains the team
  @ERJobConverter()
  ER<Team> team;

  // if  ForwardCallsTo == IVR then this contains the IVR settings
  @ERIVRConverter()
  ER<IVR> ivr = ER(IVR());

  @ERConverterConference()
  ER<Conference> conference = ER(Conference());

  CallForwardTarget();

  CallForwardTarget.forInsert() : super.forInsert() {
    messageMethod = MessageMethod.GENERATED;
    forwardCallsTo = ForwardCallsTo.COLLEAGUE;
    colleague = ER.fromGUID(Repos().user.loggedInUserGUID);
  }

  bool isGeneratePlayback() {
    return messageMethod == MessageMethod.GENERATED;
  }

  String shortDescription() {
    String description;

    switch (forwardCallsTo) {
      case ForwardCallsTo.COLLEAGUE:
        description = 'Colleague'; // colleague?.fullname ?? "";
        break;
      case ForwardCallsTo.VOICEMAIL:
        description = 'Voicemail';
        break;
      case ForwardCallsTo.EXTERNAL_NO:
        description = 'External No.'; //externalNo?.toNational() ?? "";
        break;
      case ForwardCallsTo.IVR:
        description =
            'Caller chooses'; // Caller's choice, Voice Menu, Caller Menu, Menu, Ask Caller, Present Options, Offer Options
        // Caller Options, Selection, Preference, Select, Voice Select, Caller Select, table of content, tree, branch, offshoot, speciality
        // Direction, Caller Directed, guided, Assisted, Faciltated
        break;
      case ForwardCallsTo.MESSAGE:
        description = 'Message';
        break;
      case ForwardCallsTo.TEAM:
        description = 'Team';
        break;
      case ForwardCallsTo.CONFERENCE:
        description = 'Voice Conference';
        break;
    }
    return description;
  }

  Future<String> get targetDescription async {
    String description;

    // IVR ivr = await this.ivr.future;
    // Team team = await this.team.future;

    switch (forwardCallsTo) {
      case ForwardCallsTo.COLLEAGUE:
        description = (await colleague.resolve).fullname;
        break;
      case ForwardCallsTo.VOICEMAIL:
        description = 'voicemail';
        break;
      case ForwardCallsTo.EXTERNAL_NO:
        description = externalNo?.toNational();
        break;
      case ForwardCallsTo.IVR:
        description =
            'options (${(await ivr.resolve).optionsCount.toString()})';
        break;
      case ForwardCallsTo.MESSAGE:
        description = 'a message';
        break;
      case ForwardCallsTo.TEAM:
        description = (await team.resolve).name;
        break;
      case ForwardCallsTo.CONFERENCE:
        description = (await conference.resolve).name;
        break;
    }
    return description;
  }

  Future<String> get diversionDescription async {
    return 'diverted to ${await targetDescription}';
  }

  @override
  String toString() {
    return ForwardCallsToHelper.getName(forwardCallsTo);
  }

  factory CallForwardTarget.fromJson(Map<String, dynamic> json) =>
      _$CallForwardTargetFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CallForwardTargetToJson(this);
}
