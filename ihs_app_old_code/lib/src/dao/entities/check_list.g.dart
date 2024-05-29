// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Checklist _$ChecklistFromJson(Map<String, dynamic> json) => Checklist()
  ..id = json['id'] as int?
  ..guid = const GUIDConverter().fromJson(json['guid'])
  ..checkListItem = (json['checkListItem'] as List<dynamic>)
      .map((e) => const ERConverterJob().fromJson(e as String))
      .toList();

Map<String, dynamic> _$ChecklistToJson(Checklist instance) => <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'checkListItem':
          instance.checkListItem.map(const ERConverterJob().toJson).toList(),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
