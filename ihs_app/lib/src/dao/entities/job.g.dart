// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job()
  ..id = json['id'] as int?
  ..guid = const GUIDConverter().fromJson(json['guid'])
  ..owner = const ERConverterOrganisation().fromJson(json['owner'] as String)
  ..customer = const ERConverterCustomer().fromJson(json['customer'] as String)
  ..contacts = (json['contacts'] as List<dynamic>)
      .map((e) => const ERConverterContactRole().fromJson(e as String))
      .toList()
  ..attachments = (json['attachments'] as List<dynamic>)
      .map((e) => const ERConverterAttachment().fromJson(e as String))
      .toList()
  ..stage = const ERConverterStage().fromJson(json['stage'] as String)
  ..assignedTo = const ERConverterUser().fromJson(json['assignedTo'] as String)
  ..name = json['name'] as String
  ..description = json['description'] as String
  ..startTime = json['startTime'] == null
      ? null
      : DateTime.parse(json['startTime'] as String)
  ..tasks = (json['tasks'] as List<dynamic>)
      .map((e) => const ERConverterTask().fromJson(e as String))
      .toList()
  ..activities = (json['activities'] as List<dynamic>)
      .map((e) => const ERConverterActivity().fromJson(e as String))
      .toList();

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'owner': const ERConverterOrganisation().toJson(instance.owner),
      'customer': const ERConverterCustomer().toJson(instance.customer),
      'contacts':
          instance.contacts.map(const ERConverterContactRole().toJson).toList(),
      'attachments': instance.attachments
          .map(const ERConverterAttachment().toJson)
          .toList(),
      'stage': const ERConverterStage().toJson(instance.stage),
      'assignedTo': const ERConverterUser().toJson(instance.assignedTo),
      'name': instance.name,
      'description': instance.description,
      'startTime': instance.startTime?.toIso8601String(),
      'tasks': instance.tasks.map(const ERConverterTask().toJson).toList(),
      'activities':
          instance.activities.map(const ERConverterActivity().toJson).toList(),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
