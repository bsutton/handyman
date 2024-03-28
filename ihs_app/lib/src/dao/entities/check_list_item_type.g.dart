// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_list_item_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistItemType _$ChecklistItemTypeFromJson(Map<String, dynamic> json) =>
    ChecklistItemType()
      ..id = json['id'] as int?
      ..guid = const GUIDConverter().fromJson(json['guid'])
      ..owner = const ERConverterCustomer().fromJson(json['owner'] as String)
      ..name = json['name'] as String
      ..description = json['description'] as String;

Map<String, dynamic> _$ChecklistItemTypeToJson(ChecklistItemType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'owner': const ERConverterCustomer().toJson(instance.owner),
      'name': instance.name,
      'description': instance.description,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
