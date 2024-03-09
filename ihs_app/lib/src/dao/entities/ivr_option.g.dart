// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ivr_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IVROption _$IVROptionFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['id', 'guid', 'ordinal', 'name', 'callForwardTarget']);
  return IVROption(
    json['ordinal'] as int,
  )
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..name = json['name'] as String
    ..callForwardTarget = const ERCallForwardTargetConverter().fromJson(json['callForwardTarget'] as String);
}

Map<String, dynamic> _$IVROptionToJson(IVROption instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'ordinal': instance.ordinal,
      'name': instance.name,
      'callForwardTarget': const ERCallForwardTargetConverter().toJson(instance.callForwardTarget),
    };
