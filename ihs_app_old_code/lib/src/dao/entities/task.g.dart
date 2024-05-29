// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task()
  ..id = json['id'] as int?
  ..guid = const GUIDConverter().fromJson(json['guid'])
  ..job = const ERConverterJob().fromJson(json['job'] as String)
  ..name = json['name'] as String
  ..description = json['description'] as String
  ..status = $enumDecode(_$TaskStatusEnumMap, json['status'])
  ..startDate = _$JsonConverterFromJson<String, LocalDate>(
      json['startDate'], const LocalDateConverter().fromJson)
  ..startTime = _$JsonConverterFromJson<String, LocalTime>(
      json['startTime'], const LocalTimeConverter().fromJson)
  ..activities = (json['activities'] as List<dynamic>)
      .map((e) => const ERConverterActivity().fromJson(e as String))
      .toList()
  ..attachments = (json['attachments'] as List<dynamic>)
      .map((e) => const ERConverterAttachment().fromJson(e as String))
      .toList();

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'job': const ERConverterJob().toJson(instance.job),
      'name': instance.name,
      'description': instance.description,
      'status': _$TaskStatusEnumMap[instance.status],
      'startDate': _$JsonConverterToJson<String, LocalDate>(
          instance.startDate, const LocalDateConverter().toJson),
      'startTime': _$JsonConverterToJson<String, LocalTime>(
          instance.startTime, const LocalTimeConverter().toJson),
      'activities':
          instance.activities.map(const ERConverterActivity().toJson).toList(),
      'attachments': instance.attachments
          .map(const ERConverterAttachment().toJson)
          .toList(),
    };

const _$TaskStatusEnumMap = {
  TaskStatus.toBeScheduled: 'toBeScheduled',
  TaskStatus.scheduled: 'scheduled',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.paused: 'paused',
  TaskStatus.completed: 'completed',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
