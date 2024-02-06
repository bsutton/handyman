// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'limit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Limit _$LimitFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['id', 'guid', 'user', 'type', 'description', 'options', 'currentOption']);
  return Limit()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..user = const ERUserConverter().fromJson(json['user'] as String)
    ..type = _$enumDecodeNullable(_$LimitTypeEnumMap, json['type'])
    ..description = json['description'] as String
    ..options =
        (json['options'] as List)?.map((dynamic e) => const ERLimitOptionConverter().fromJson(e as String))?.toList()
    ..currentOption = const ERLimitOptionConverter().fromJson(json['currentOption'] as String);
}

Map<String, dynamic> _$LimitToJson(Limit instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'user': const ERUserConverter().toJson(instance.user),
      'type': _$LimitTypeEnumMap[instance.type],
      'description': instance.description,
      'options': instance.options?.map(const ERLimitOptionConverter().toJson)?.toList(),
      'currentOption': const ERLimitOptionConverter().toJson(instance.currentOption),
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

const _$LimitTypeEnumMap = {
  LimitType.VoicemailMaxMessageStorage: 'VoicemailMaxMessageStorage',
};
