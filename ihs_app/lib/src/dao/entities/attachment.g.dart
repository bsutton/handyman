// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map<String, dynamic> json) => Attachment()
  ..id = json['id'] as int?
  ..guid = const GUIDConverter().fromJson(json['guid'])
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..storageType = $enumDecode(_$AttachmentStorageEnumMap, json['storageType'])
  ..url = json['url'] as String?;

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'name': instance.name,
      'description': instance.description,
      'storageType': _$AttachmentStorageEnumMap[instance.storageType]!,
      'url': instance.url,
    };

const _$AttachmentStorageEnumMap = {
  AttachmentStorage.url: 'url',
  AttachmentStorage.file: 'file',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
