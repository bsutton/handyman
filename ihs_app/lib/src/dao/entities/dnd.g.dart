// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dnd.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DND _$DNDFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['id', 'guid', 'owner', 'forcedOn', 'callForwardTarget', 'endTime']);
  return DND(
    const ERUserConverter().fromJson(json['owner'] as String),
  )
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..forcedOn = json['forcedOn'] as bool
    ..callForwardTarget = const ERCallForwardTargetConverter().fromJson(json['callForwardTarget'] as String)
    ..endTime = json['endTime'] == null ? null : DateTime.parse(json['endTime'] as String);
}

Map<String, dynamic> _$DNDToJson(DND instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'owner': const ERUserConverter().toJson(instance.owner),
      'forcedOn': instance.forcedOn,
      'callForwardTarget': const ERCallForwardTargetConverter().toJson(instance.callForwardTarget),
      'endTime': instance.endTime?.toIso8601String(),
    };
