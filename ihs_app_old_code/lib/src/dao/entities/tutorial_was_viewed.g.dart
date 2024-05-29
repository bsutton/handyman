// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial_was_viewed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TutorialWasViewed _$TutorialWasViewedFromJson(Map<String, dynamic> json) =>
    TutorialWasViewed(
      user: _$JsonConverterFromJson<String, ER<User>>(
          json['user'], const ERConverterUser().fromJson),
      tutorial: _$JsonConverterFromJson<String, ER<Tutorial>>(
          json['tutorial'], const ERTutorialConverter().fromJson),
      dateViewed: _$JsonConverterFromJson<String, LocalDate>(
          json['dateViewed'], const LocalDateConverter().fromJson),
    )
      ..id = json['id'] as int?
      ..guid = const GUIDConverter().fromJson(json['guid']);

Map<String, dynamic> _$TutorialWasViewedToJson(TutorialWasViewed instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'user': _$JsonConverterToJson<String, ER<User>>(
          instance.user, const ERConverterUser().toJson),
      'tutorial': _$JsonConverterToJson<String, ER<Tutorial>>(
          instance.tutorial, const ERTutorialConverter().toJson),
      'dateViewed': _$JsonConverterToJson<String, LocalDate>(
          instance.dateViewed, const LocalDateConverter().toJson),
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
