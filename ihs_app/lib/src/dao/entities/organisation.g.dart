// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organisation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organisation _$OrganisationFromJson(Map<String, dynamic> json) => Organisation()
  ..id = json['id'] as int?
  ..guid = const GUIDConverter().fromJson(json['guid'])
  ..name = json['name'] as String;

Map<String, dynamic> _$OrganisationToJson(Organisation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'name': instance.name,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
