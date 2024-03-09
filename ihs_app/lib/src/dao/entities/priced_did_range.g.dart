// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'priced_did_range.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PricedDIDRange _$PricedDIDRangeFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['valuationType', 'owner', 'pool', 'region', 'didRange', 'chargePrice']);
  return PricedDIDRange(
    const ERRegionConverter().fromJson(json['region'] as String),
    json['didRange'] == null ? null : DIDRange.fromJson(json['didRange'] as Map<String, dynamic>),
    const MoneyConverter().fromJson(json['chargePrice'] as String),
    _$enumDecodeNullable(_$ValuationTypeEnumMap, json['valuationType']),
  )
    ..owner = const ERCustomerConverter().fromJson(json['owner'] as String)
    ..pool = const ERDIDPoolConverter().fromJson(json['pool'] as String);
}

Map<String, dynamic> _$PricedDIDRangeToJson(PricedDIDRange instance) => <String, dynamic>{
      'valuationType': _$ValuationTypeEnumMap[instance.valuationType],
      'owner': const ERCustomerConverter().toJson(instance.owner),
      'pool': const ERDIDPoolConverter().toJson(instance.pool),
      'region': const ERRegionConverter().toJson(instance.region),
      'didRange': instance.didRange,
      'chargePrice': const MoneyConverter().toJson(instance.chargePrice),
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

const _$ValuationTypeEnumMap = {
  ValuationType.PREMIUM: 'PREMIUM',
  ValuationType.NON_PREMIUM: 'NON_PREMIUM',
};
