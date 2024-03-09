// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_invitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInvitation _$UserInvitationFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'type',
    'owner',
    'invitedBy',
    'invitee',
    'mobile',
    'created',
    'expires',
    'state',
    'ipAddress',
    'location',
    'device'
  ]);
  return UserInvitation(
    const ERCustomerConverter().fromJson(json['owner'] as String),
    const ERUserConverter().fromJson(json['invitedBy'] as String),
    const ERUserConverter().fromJson(json['invitee'] as String),
    _$enumDecodeNullable(_$InvitationTypeEnumMap, json['type']),
  )
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..mobile = const PhoneNumberConverter().fromJson(json['mobile'] as String)
    ..created = json['created'] == null ? null : DateTime.parse(json['created'] as String)
    ..expires = json['expires'] == null ? null : DateTime.parse(json['expires'] as String)
    ..state = _$enumDecodeNullable(_$InvitationStateEnumMap, json['state'])
    ..ipAddress = json['ipAddress'] as String
    ..location = json['location'] as String
    ..device = json['device'] as String;
}

Map<String, dynamic> _$UserInvitationToJson(UserInvitation instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'type': _$InvitationTypeEnumMap[instance.type],
      'owner': const ERCustomerConverter().toJson(instance.owner),
      'invitedBy': const ERUserConverter().toJson(instance.invitedBy),
      'invitee': const ERUserConverter().toJson(instance.invitee),
      'mobile': const PhoneNumberConverter().toJson(instance.mobile),
      'created': instance.created?.toIso8601String(),
      'expires': instance.expires?.toIso8601String(),
      'state': _$InvitationStateEnumMap[instance.state],
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

const _$InvitationTypeEnumMap = {
  InvitationType.NEW_USER: 'NEW_USER',
  InvitationType.EXISTING_USER: 'EXISTING_USER',
  InvitationType.RECOVERY: 'RECOVERY',
};

const _$InvitationStateEnumMap = {
  InvitationState.INITIAL: 'INITIAL',
  InvitationState.EXPIRED: 'EXPIRED',
  InvitationState.NOT_FOUND: 'NOT_FOUND',
  InvitationState.MOBILE_VALIDATED: 'MOBILE_VALIDATED',
  InvitationState.EMAIL_VALIDATED: 'EMAIL_VALIDATED',
  InvitationState.BOTH_VALIDATED: 'BOTH_VALIDATED',
  InvitationState.ACTIVATED: 'ACTIVATED',
  InvitationState.EXCEPTION: 'EXCEPTION',
};
