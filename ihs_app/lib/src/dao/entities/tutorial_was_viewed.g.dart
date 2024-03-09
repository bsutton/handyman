// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial_was_viewed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TutorialWasViewed _$TutorialWasViewedFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['id', 'guid', 'user', 'tutorial', 'dateViewed']);
  return TutorialWasViewed(
    user: const ERUserConverter().fromJson(json['user'] as String),
    tutorial: const ERTutorialConverter().fromJson(json['tutorial'] as String),
    dateViewed: const LocalDateConverter().fromJson(json['dateViewed'] as String),
  )
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid']);
}

Map<String, dynamic> _$TutorialWasViewedToJson(TutorialWasViewed instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'user': const ERUserConverter().toJson(instance.user),
      'tutorial': const ERTutorialConverter().toJson(instance.tutorial),
      'dateViewed': const LocalDateConverter().toJson(instance.dateViewed),
    };
