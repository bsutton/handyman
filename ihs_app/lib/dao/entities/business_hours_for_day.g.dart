// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_hours_for_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessHoursForDay _$BusinessHoursForDayFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'owner',
    'team',
    'dayOfWeek',
    'open',
    'openingTime',
    'closingTime'
  ]);
  return BusinessHoursForDay()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..owner = const ERCustomerConverter().fromJson(json['owner'] as String)
    ..team = const ERJobConverter().fromJson(json['team'] as String)
    ..dayOfWeek = const DayOfWeekConverter().fromJson(json['dayOfWeek'] as int)
    ..open = json['open'] as bool
    ..openingTime =
        const LocalTimeConverter().fromJson(json['openingTime'] as String)
    ..closingTime =
        const LocalTimeConverter().fromJson(json['closingTime'] as String);
}

Map<String, dynamic> _$BusinessHoursForDayToJson(
        BusinessHoursForDay instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'owner': const ERCustomerConverter().toJson(instance.owner),
      'team': const ERJobConverter().toJson(instance.team),
      'dayOfWeek': const DayOfWeekConverter().toJson(instance.dayOfWeek),
      'open': instance.open,
      'openingTime': const LocalTimeConverter().toJson(instance.openingTime),
      'closingTime': const LocalTimeConverter().toJson(instance.closingTime),
    };
