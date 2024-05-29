// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity()
  ..id = json['id'] as int?
  ..guid = const GUIDConverter().fromJson(json['guid'])
  ..comment = json['comment'] as String
  ..createdDate = DateTime.parse(json['createdDate'] as String);

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'comment': instance.comment,
      'createdDate': instance.createdDate.toIso8601String(),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
