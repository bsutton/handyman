// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voicemail_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoicemailMessage _$VoicemailMessageFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'voicemailBox',
    'when',
    'duration',
    'from',
    'markedAsDeleted',
    'audioFileGuid',
    'audioFile',
    'noojeeContactId',
    'voicemailRead',
    'fireBaseNotificationSent'
  ]);
  return VoicemailMessage()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..voicemailBox = const ERVoicemailBoxConverter().fromJson(json['voicemailBox'] as String)
    ..when = json['when'] == null ? null : DateTime.parse(json['when'] as String)
    ..duration = json['duration'] == null ? null : Duration(microseconds: json['duration'] as int)
    ..from = const ERCallerDetailsConverter().fromJson(json['from'] as String)
    ..markedAsDeleted = json['markedAsDeleted'] == null ? null : DateTime.parse(json['markedAsDeleted'] as String)
    ..audioFileGuid = const GUIDConverter().fromJson(json['audioFileGuid'])
    ..audioFile = const ERAudioFileConverter().fromJson(json['audioFile'] as String)
    ..noojeeContactId = json['noojeeContactId'] as int
    ..voicemailRead = json['voicemailRead'] as bool
    ..fireBaseNotificationSent = json['fireBaseNotificationSent'] as bool;
}

Map<String, dynamic> _$VoicemailMessageToJson(VoicemailMessage instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'voicemailBox': const ERVoicemailBoxConverter().toJson(instance.voicemailBox),
      'when': instance.when?.toIso8601String(),
      'duration': instance.duration?.inMicroseconds,
      'from': const ERCallerDetailsConverter().toJson(instance.from),
      'markedAsDeleted': instance.markedAsDeleted?.toIso8601String(),
      'audioFileGuid': const GUIDConverter().toJson(instance.audioFileGuid),
      'audioFile': const ERAudioFileConverter().toJson(instance.audioFile),
      'noojeeContactId': instance.noojeeContactId,
      'voicemailRead': instance.voicemailRead,
      'fireBaseNotificationSent': instance.fireBaseNotificationSent,
    };
