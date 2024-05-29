// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Role _$RoleFromJson(Map<String, dynamic> json) => Role()
  ..id = json['id'] as int?
  ..guid = const GUIDConverter().fromJson(json['guid'])
  ..owner = const ERConverterOrganisation().fromJson(json['owner'] as String)
  ..name = json['name'] as String
  ..description = json['description'] as String;

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'owner': const ERConverterOrganisation().toJson(instance.owner),
      'name': instance.name,
      'description': instance.description,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
