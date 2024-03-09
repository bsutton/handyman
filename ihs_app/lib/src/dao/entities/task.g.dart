// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Leave _$LeaveFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['id', 'guid', 'owner', 'active', 'startDate', 'endDate', 'callForwardTarget']);
  return Leave(
    const ERUserConverter().fromJson(json['owner'] as String),
  )
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..active = json['active'] as bool
    ..startDate = const LocalDateConverter().fromJson(json['startDate'] as String)
    ..endDate = const LocalDateConverter().fromJson(json['endDate'] as String)
    ..callForwardTarget = const ERCallForwardTargetConverter().fromJson(json['callForwardTarget'] as String);
}

Map<String, dynamic> _$LeaveToJson(Leave instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'owner': const ERUserConverter().toJson(instance.owner),
      'active': instance.active,
      'startDate': const LocalDateConverter().toJson(instance.startDate),
      'endDate': const LocalDateConverter().toJson(instance.endDate),
      'callForwardTarget': const ERCallForwardTargetConverter().toJson(instance.callForwardTarget),
    };
