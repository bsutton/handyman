import 'package:json_annotation/json_annotation.dart';

import '../types/er.dart';
import 'check_list_item.dart';
import 'contact.dart';
import 'entity.dart';
import 'voicemail_box.dart';

part 'voicemail_message.g.dart';

@JsonSerializable()
class VoicemailMessage extends Entity<VoicemailMessage> {
  @ERVoicemailBoxConverter()
  ER<VoicemailBox> voicemailBox;

  DateTime when;

  ///
  /// For performance reasons we copy this here from the AudioFile.
  ///
  Duration duration;

  @ERCallerDetailsConverter()
  ER<Contact> from;

  DateTime markedAsDeleted;

  @GUIDConverter()
  GUID audioFileGuid;

  @ERAudioFileConverter()
  ER<AudioFile> audioFile;

  ///
  /// The id of the voicemail message when it was created on Noojee contact. Used to ensure that we don't process
  /// duplicate messages.
  ///
  int noojeeContactId;

  ///
  /// If true the message has been read by a user
  ///
  bool voicemailRead = false;

  ///

  /// Tracks if a firebase notification has been sent to the user.
  ///
  bool fireBaseNotificationSent = false;

  // required by json.
  VoicemailMessage();

  factory VoicemailMessage.fromJson(Map<String, dynamic> json) =>
      _$VoicemailMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$VoicemailMessageToJson(this);

  VoicemailMessage.mock(String firstname, String surname, String company,
      String mobile, String landline);
}
