// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) =>
    ChecklistItem()
      ..id = json['id'] as int?
      ..guid = const GUIDConverter().fromJson(json['guid'])
      ..owner =
          const ERConverterOrganisation().fromJson(json['owner'] as String)
      ..created = DateTime.parse(json['created'] as String)
      ..name = json['name'] as String
      ..checkListItemType = const ERConverterChecklistItemType()
          .fromJson(json['checkListItemType'] as String);

Map<String, dynamic> _$ChecklistItemToJson(ChecklistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'owner': const ERConverterOrganisation().toJson(instance.owner),
      'created': instance.created.toIso8601String(),
      'name': instance.name,
      'checkListItemType': const ERConverterChecklistItemType()
          .toJson(instance.checkListItemType),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
