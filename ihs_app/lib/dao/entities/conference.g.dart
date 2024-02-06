// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conference _$ConferenceFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'createdBy',
    'host',
    'name',
    'description',
    'startTime',
    'earlyCheckinTime',
    'estimatedDuration',
    'whoSpeaks',
    'participants'
  ]);
  return Conference()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..createdBy = const ERUserConverter().fromJson(json['createdBy'] as String)
    ..host = const ERUserConverter().fromJson(json['host'] as String)
    ..name = json['name'] as String
    ..description = json['description'] as String
    ..startTime = json['startTime'] == null ? null : DateTime.parse(json['startTime'] as String)
    ..earlyCheckinTime = json['earlyCheckinTime'] == null ? null : DateTime.parse(json['earlyCheckinTime'] as String)
    ..estimatedDuration =
        json['estimatedDuration'] == null ? null : Duration(microseconds: json['estimatedDuration'] as int)
    ..whoSpeaks = _$enumDecodeNullable(_$WhoSpeaksEnumMap, json['whoSpeaks'])
    ..participants = (json['participants'] as List)
        ?.map((dynamic e) => const ERParticipantConverter().fromJson(e as String))
        ?.toList();
}

Map<String, dynamic> _$ConferenceToJson(Conference instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'createdBy': const ERUserConverter().toJson(instance.createdBy),
      'host': const ERUserConverter().toJson(instance.host),
      'name': instance.name,
      'description': instance.description,
      'startTime': instance.startTime?.toIso8601String(),
      'earlyCheckinTime': instance.earlyCheckinTime?.toIso8601String(),
      'estimatedDuration': instance.estimatedDuration?.inMicroseconds,
      'whoSpeaks': _$WhoSpeaksEnumMap[instance.whoSpeaks],
      'participants': instance.participants?.map(const ERParticipantConverter().toJson)?.toList(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries.singleWhere((e) => e.value == source, orElse: () => null)?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$WhoSpeaksEnumMap = {
  WhoSpeaks.EVERYONE: 'EVERYONE',
  WhoSpeaks.PRESENTERS: 'PRESENTERS',
};
