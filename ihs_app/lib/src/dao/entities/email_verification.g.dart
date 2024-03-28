// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailVerification _$EmailVerificationFromJson(Map<String, dynamic> json) =>
    EmailVerification()
      ..id = json['id'] as int?
      ..guid = const GUIDConverter().fromJson(json['guid'])
      ..type = $enumDecode(_$EmailVerificationTypeEnumMap, json['type'])
      ..invitationGUID = GUID.fromJson(json['invitationGUID'])
      ..created = DateTime.parse(json['created'] as String)
      ..emailAddress = json['emailAddress'] as String
      ..expires = DateTime.parse(json['expires'] as String)
      ..verified = json['verified'] as bool
      ..ipAddress = json['ipAddress'] as String?
      ..location = json['location'] as String?
      ..device = json['device'] as String?;

Map<String, dynamic> _$EmailVerificationToJson(EmailVerification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'type': _$EmailVerificationTypeEnumMap[instance.type]!,
      'invitationGUID': instance.invitationGUID,
      'created': instance.created.toIso8601String(),
      'emailAddress': instance.emailAddress,
      'expires': instance.expires.toIso8601String(),
      'verified': instance.verified,
      'ipAddress': instance.ipAddress,
      'location': instance.location,
      'device': instance.device,
    };

const _$EmailVerificationTypeEnumMap = {
  EmailVerificationType.RECOVERY: 'RECOVERY',
  EmailVerificationType.INVITE: 'INVITE',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
