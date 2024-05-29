// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistTemplate _$ChecklistTemplateFromJson(Map<String, dynamic> json) =>
    ChecklistTemplate()
      ..id = json['id'] as int?
      ..guid = const GUIDConverter().fromJson(json['guid'])
      ..owner =
          const ERConverterOrganisation().fromJson(json['owner'] as String)
      ..name = json['name'] as String
      ..taskItems = (json['taskItems'] as List<dynamic>)
          .map((e) => const ERConverterChecklistItem().fromJson(e as String))
          .toList();

Map<String, dynamic> _$ChecklistTemplateToJson(ChecklistTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'owner': const ERConverterOrganisation().toJson(instance.owner),
      'name': instance.name,
      'taskItems': instance.taskItems
          .map(const ERConverterChecklistItem().toJson)
          .toList(),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
