// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office_holidays.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficeHolidays _$OfficeHolidaysFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      allowedKeys: const ['id', 'guid', 'owner', 'active', 'start', 'end', 'callForwardTarget', 'timezone']);
  return OfficeHolidays()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..owner = const ERCustomerConverter().fromJson(json['owner'] as String)
    ..active = json['active'] as bool
    ..start = const LocalDateConverter().fromJson(json['start'] as String)
    ..end = const LocalDateConverter().fromJson(json['end'] as String)
    ..callForwardTarget = const ERCallForwardTargetConverter().fromJson(json['callForwardTarget'] as String)
    ..timezone = const TimezoneConverter().fromJson(json['timezone'] as Map<String, dynamic>);
}

Map<String, dynamic> _$OfficeHolidaysToJson(OfficeHolidays instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'owner': const ERCustomerConverter().toJson(instance.owner),
      'active': instance.active,
      'start': const LocalDateConverter().toJson(instance.start),
      'end': const LocalDateConverter().toJson(instance.end),
      'callForwardTarget': const ERCallForwardTargetConverter().toJson(instance.callForwardTarget),
      'timezone': const TimezoneConverter().toJson(instance.timezone),
    };
