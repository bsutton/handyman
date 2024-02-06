// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ivr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IVR _$IVRFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['id', 'guid', 'ivrOptions']);
  return IVR()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..ivrOptions =
        (json['ivrOptions'] as List)?.map((dynamic e) => const ERIVROptionConverter().fromJson(e as String))?.toList();
}

Map<String, dynamic> _$IVRToJson(IVR instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'ivrOptions': instance.ivrOptions?.map(const ERIVROptionConverter().toJson)?.toList(),
    };
