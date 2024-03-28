// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_invitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInvitation _$UserInvitationFromJson(Map<String, dynamic> json) =>
    UserInvitation(
      const ERConverterCustomer().fromJson(json['owner'] as String),
      const ERConverterUser().fromJson(json['invitedBy'] as String),
      const ERConverterUser().fromJson(json['invitee'] as String),
      $enumDecode(_$InvitationTypeEnumMap, json['type']),
    )
      ..id = json['id'] as int?
      ..guid = const GUIDConverter().fromJson(json['guid'])
      ..mobile = const ConverterPhoneNumber().fromJson(json['mobile'] as String)
      ..created = DateTime.parse(json['created'] as String)
      ..expires = json['expires'] == null
          ? null
          : DateTime.parse(json['expires'] as String)
      ..state = $enumDecode(_$InvitationStateEnumMap, json['state'])
      ..ipAddress = json['ipAddress'] as String?
      ..location = json['location'] as String?
      ..device = json['device'] as String?;

Map<String, dynamic> _$UserInvitationToJson(UserInvitation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'type': _$InvitationTypeEnumMap[instance.type]!,
      'owner': const ERConverterCustomer().toJson(instance.owner),
      'invitedBy': const ERConverterUser().toJson(instance.invitedBy),
      'invitee': const ERConverterUser().toJson(instance.invitee),
      'mobile': const ConverterPhoneNumber().toJson(instance.mobile),
      'created': instance.created.toIso8601String(),
      'expires': instance.expires?.toIso8601String(),
      'state': _$InvitationStateEnumMap[instance.state]!,
      'ipAddress': instance.ipAddress,
      'location': instance.location,
      'device': instance.device,
    };

const _$InvitationTypeEnumMap = {
  InvitationType.newOrganisation: 'newOrganisation',
  InvitationType.newUser: 'newUser',
  InvitationType.existingUser: 'existingUser',
  InvitationType.recovery: 'recovery',
};

const _$InvitationStateEnumMap = {
  InvitationState.initial: 'initial',
  InvitationState.expired: 'expired',
  InvitationState.notFound: 'notFound',
  InvitationState.mobileValidated: 'mobileValidated',
  InvitationState.emailValidated: 'emailValidated',
  InvitationState.bothValidated: 'bothValidated',
  InvitationState.activated: 'activated',
  InvitationState.exception: 'exception',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
