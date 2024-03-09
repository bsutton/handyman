// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailVerification _$EmailVerificationFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'type',
    'invitationGUID',
    'created',
    'emailAddress',
    'expires',
    'verified',
    'ipAddress',
    'location',
    'device'
  ]);
  return EmailVerification()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..type = _$enumDecodeNullable(_$EmailVerificationTypeEnumMap, json['type'])
    ..invitationGUID = json['invitationGUID'] == null ? null : GUID.fromJson(json['invitationGUID'])
    ..created = json['created'] == null ? null : DateTime.parse(json['created'] as String)
    ..emailAddress = json['emailAddress'] as String
    ..expires = json['expires'] == null ? null : DateTime.parse(json['expires'] as String)
    ..verified = json['verified'] as bool
    ..ipAddress = json['ipAddress'] as String
    ..location = json['location'] as String
    ..device = json['device'] as String;
}

Map<String, dynamic> _$EmailVerificationToJson(EmailVerification instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'type': _$EmailVerificationTypeEnumMap[instance.type],
      'invitationGUID': instance.invitationGUID,
      'created': instance.created?.toIso8601String(),
      'emailAddress': instance.emailAddress,
      'expires': instance.expires?.toIso8601String(),
      'verified': instance.verified,
      'ipAddress': instance.ipAddress,
      'location': instance.location,
      'device': instance.device,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries.singleWhere((e) => e.value == source, orElse: () => null)?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$EmailVerificationTypeEnumMap = {
  EmailVerificationType.RECOVERY: 'RECOVERY',
  EmailVerificationType.INVITE: 'INVITE',
};
