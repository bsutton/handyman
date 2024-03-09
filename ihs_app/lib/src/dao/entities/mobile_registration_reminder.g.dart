// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_registration_reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileRegistrationReminder _$MobileRegistrationReminderFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      allowedKeys: const ['id', 'guid', 'progressUUID', 'mobile', 'registrationDateTime', 'firstReminder']);
  return MobileRegistrationReminder()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..progressUUID = json['progressUUID'] as String
    ..mobile = const PhoneNumberConverter().fromJson(json['mobile'] as String)
    ..registrationDateTime =
        json['registrationDateTime'] == null ? null : DateTime.parse(json['registrationDateTime'] as String)
    ..firstReminder = json['firstReminder'] == null ? null : DateTime.parse(json['firstReminder'] as String);
}

Map<String, dynamic> _$MobileRegistrationReminderToJson(MobileRegistrationReminder instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'progressUUID': instance.progressUUID,
      'mobile': const PhoneNumberConverter().toJson(instance.mobile),
      'registrationDateTime': instance.registrationDateTime?.toIso8601String(),
      'firstReminder': instance.firstReminder?.toIso8601String(),
    };
