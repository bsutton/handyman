// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tutorial _$TutorialFromJson(Map<String, dynamic> json) => Tutorial(
      summary: json['summary'] as String?,
      serialVersionUID: json['serialVersionUID'] as int?,
      htmlBody: json['htmlBody'] as String?,
      subject: json['subject'] as String?,
      urlToVideoMedia: json['urlToVideoMedia'] as String?,
      guid: const GUIDConverter().fromJson(json['guid']),
      id: json['id'] as int?,
      body: json['body'] as String?,
      type: json['type'] as String?,
      creationDate: _$JsonConverterFromJson<String, LocalDate>(
          json['creationDate'], const LocalDateConverter().fromJson),
    );

Map<String, dynamic> _$TutorialToJson(Tutorial instance) => <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'summary': instance.summary,
      'serialVersionUID': instance.serialVersionUID,
      'htmlBody': instance.htmlBody,
      'subject': instance.subject,
      'urlToVideoMedia': instance.urlToVideoMedia,
      'body': instance.body,
      'type': instance.type,
      'creationDate': _$JsonConverterToJson<String, LocalDate>(
          instance.creationDate, const LocalDateConverter().toJson),
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
