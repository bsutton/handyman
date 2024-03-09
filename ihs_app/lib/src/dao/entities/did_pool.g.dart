// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'did_pool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DIDPool _$DIDPoolFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'australianState',
    'country',
    'didRange',
    'premium1Charge',
    'nonPremium1Charge',
    'premium100Charge',
    'nonPremium100Charge',
    'poolStatus'
  ]);
  return DIDPool()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..australianState = _$enumDecodeNullable(_$AustralianStateEnumMap, json['australianState'])
    ..country = const ERCountryConverter().fromJson(json['country'] as String)
    ..didRange = json['didRange'] == null ? null : DIDRange.fromJson(json['didRange'] as Map<String, dynamic>)
    ..premium1Charge = const MoneyConverter().fromJson(json['premium1Charge'] as String)
    ..nonPremium1Charge = const MoneyConverter().fromJson(json['nonPremium1Charge'] as String)
    ..premium100Charge = const MoneyConverter().fromJson(json['premium100Charge'] as String)
    ..nonPremium100Charge = const MoneyConverter().fromJson(json['nonPremium100Charge'] as String)
    ..poolStatus = _$enumDecodeNullable(_$PoolStatusEnumMap, json['poolStatus']);
}

Map<String, dynamic> _$DIDPoolToJson(DIDPool instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'australianState': _$AustralianStateEnumMap[instance.australianState],
      'country': const ERCountryConverter().toJson(instance.country),
      'didRange': instance.didRange,
      'premium1Charge': const MoneyConverter().toJson(instance.premium1Charge),
      'nonPremium1Charge': const MoneyConverter().toJson(instance.nonPremium1Charge),
      'premium100Charge': const MoneyConverter().toJson(instance.premium100Charge),
      'nonPremium100Charge': const MoneyConverter().toJson(instance.nonPremium100Charge),
      'poolStatus': _$PoolStatusEnumMap[instance.poolStatus],
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

const _$AustralianStateEnumMap = {
  AustralianState.VIC: 'VIC',
  AustralianState.NSW: 'NSW',
  AustralianState.QLD: 'QLD',
  AustralianState.TAS: 'TAS',
  AustralianState.NT: 'NT',
  AustralianState.ACT: 'ACT',
  AustralianState.WA: 'WA',
  AustralianState.SA: 'SA',
  AustralianState.International: 'International',
  AustralianState.Mobile: 'Mobile',
};

const _$PoolStatusEnumMap = {
  PoolStatus.ACTIVE: 'ACTIVE',
  PoolStatus.PENDING_DELETE: 'PENDING_DELETE',
  PoolStatus.DELETED: 'DELETED',
};
