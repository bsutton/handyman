// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'owner',
    'name',
    'region',
    'wrapTime',
    'rotation',
    'musicOnHold',
    'includeAllUsers',
    'overrideHours',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
    'callForward',
    'members'
  ]);
  return Team()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..owner = const ERCustomerConverter().fromJson(json['owner'] as String)
    ..name = json['name'] as String
    ..region = const ERRegionConverter().fromJson(json['region'] as String)
    ..wrapTime = json['wrapTime'] == null ? null : Duration(microseconds: json['wrapTime'] as int)
    ..rotation = _$enumDecodeNullable(_$MemberRotationEnumMap, json['rotation'])
    ..musicOnHold = _$enumDecodeNullable(_$MusicOnHoldEnumMap, json['musicOnHold'])
    ..includeAllUsers = json['includeAllUsers'] as bool
    ..overrideHours = const EROverrideHours().fromJson(json['overrideHours'] as String)
    ..monday = const ERBusinessHoursForDayConverter().fromJson(json['monday'] as String)
    ..tuesday = const ERBusinessHoursForDayConverter().fromJson(json['tuesday'] as String)
    ..wednesday = const ERBusinessHoursForDayConverter().fromJson(json['wednesday'] as String)
    ..thursday = const ERBusinessHoursForDayConverter().fromJson(json['thursday'] as String)
    ..friday = const ERBusinessHoursForDayConverter().fromJson(json['friday'] as String)
    ..saturday = const ERBusinessHoursForDayConverter().fromJson(json['saturday'] as String)
    ..sunday = const ERBusinessHoursForDayConverter().fromJson(json['sunday'] as String)
    ..callForward = const ERCallForwardTargetConverter().fromJson(json['callForward'] as String)
    ..members = (json['members'] as List)?.map((dynamic e) => const ERUserConverter().fromJson(e as String))?.toList();
}

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'owner': const ERCustomerConverter().toJson(instance.owner),
      'name': instance.name,
      'region': const ERRegionConverter().toJson(instance.region),
      'wrapTime': instance.wrapTime?.inMicroseconds,
      'rotation': _$MemberRotationEnumMap[instance.rotation],
      'musicOnHold': _$MusicOnHoldEnumMap[instance.musicOnHold],
      'includeAllUsers': instance.includeAllUsers,
      'overrideHours': const EROverrideHours().toJson(instance.overrideHours),
      'monday': const ERBusinessHoursForDayConverter().toJson(instance.monday),
      'tuesday': const ERBusinessHoursForDayConverter().toJson(instance.tuesday),
      'wednesday': const ERBusinessHoursForDayConverter().toJson(instance.wednesday),
      'thursday': const ERBusinessHoursForDayConverter().toJson(instance.thursday),
      'friday': const ERBusinessHoursForDayConverter().toJson(instance.friday),
      'saturday': const ERBusinessHoursForDayConverter().toJson(instance.saturday),
      'sunday': const ERBusinessHoursForDayConverter().toJson(instance.sunday),
      'callForward': const ERCallForwardTargetConverter().toJson(instance.callForward),
      'members': instance.members?.map(const ERUserConverter().toJson)?.toList(),
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

const _$MemberRotationEnumMap = {
  MemberRotation.ROUND_ROBIN: 'ROUND_ROBIN',
  MemberRotation.GROUP_RING: 'GROUP_RING',
};

const _$MusicOnHoldEnumMap = {
  MusicOnHold.JAZZ: 'JAZZ',
  MusicOnHold.CLASSIC: 'CLASSIC',
  MusicOnHold.ELEVATOR: 'ELEVATOR',
};
