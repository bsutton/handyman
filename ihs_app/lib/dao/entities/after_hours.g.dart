// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'after_hours.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AfterHours _$AfterHoursFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      allowedKeys: const ['id', 'guid', 'team', 'callForardTarget']);
  return AfterHours()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..team = const ERJobConverter().fromJson(json['team'] as String)
    ..callForardTarget = const ERCallForwardTargetConverter()
        .fromJson(json['callForardTarget'] as String);
}

Map<String, dynamic> _$AfterHoursToJson(AfterHours instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'team': const ERJobConverter().toJson(instance.team),
      'callForardTarget': const ERCallForwardTargetConverter()
          .toJson(instance.callForardTarget),
    };
