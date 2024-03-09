// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Region _$RegionFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['id', 'guid', 'country', 'state', 'city', 'timezone', 'areaCode']);
  return Region(
    const ERCountryConverter().fromJson(json['country'] as String),
    json['state'] as String,
    json['city'] as String,
    const TimezoneConverter().fromJson(json['timezone'] as Map<String, dynamic>),
    const AreaCodeConverter().fromJson(json['areaCode'] as String),
  )
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid']);
}

Map<String, dynamic> _$RegionToJson(Region instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'country': const ERCountryConverter().toJson(instance.country),
      'state': instance.state,
      'city': instance.city,
      'timezone': const TimezoneConverter().toJson(instance.timezone),
      'areaCode': const AreaCodeConverter().toJson(instance.areaCode),
    };
