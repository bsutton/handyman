// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tutorial _$TutorialFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'summary',
    'serialVersionUID',
    'htmlBody',
    'subject',
    'urlToVideoMedia',
    'body',
    'type',
    'creationDate'
  ]);
  return Tutorial(
    summary: json['summary'] as String,
    serialVersionUID: json['serialVersionUID'] as int,
    htmlBody: json['htmlBody'] as String,
    subject: json['subject'] as String,
    urlToVideoMedia: json['urlToVideoMedia'] as String,
    guid: const GUIDConverter().fromJson(json['guid']),
    id: json['id'] as int,
    body: json['body'] as String,
    type: json['type'] as String,
    creationDate: const LocalDateConverter().fromJson(json['creationDate'] as String),
  );
}

Map<String, dynamic> _$TutorialToJson(Tutorial instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'summary': instance.summary,
      'serialVersionUID': instance.serialVersionUID,
      'htmlBody': instance.htmlBody,
      'subject': instance.subject,
      'urlToVideoMedia': instance.urlToVideoMedia,
      'body': instance.body,
      'type': instance.type,
      'creationDate': const LocalDateConverter().toJson(instance.creationDate),
    };
