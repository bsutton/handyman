// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organisation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverrideHours _$OverrideHoursFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'team',
    'overrideDate',
    'openAt',
    'closeAt',
    'callForwardTarget'
  ]);
  return OverrideHours()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..team = const ERJobConverter().fromJson(json['team'] as String)
    ..overrideDate =
        const LocalDateConverter().fromJson(json['overrideDate'] as String)
    ..openAt = const LocalTimeConverter().fromJson(json['openAt'] as String)
    ..closeAt = const LocalTimeConverter().fromJson(json['closeAt'] as String)
    ..callForwardTarget = const ERCallForwardTargetConverter()
        .fromJson(json['callForwardTarget'] as String);
}

Map<String, dynamic> _$OverrideHoursToJson(OverrideHours instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'team': const ERJobConverter().toJson(instance.team),
      'overrideDate': const LocalDateConverter().toJson(instance.overrideDate),
      'openAt': const LocalTimeConverter().toJson(instance.openAt),
      'closeAt': const LocalTimeConverter().toJson(instance.closeAt),
      'callForwardTarget': const ERCallForwardTargetConverter()
          .toJson(instance.callForwardTarget),
    };
