// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'did_allocation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DIDAllocation _$DIDAllocationFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'owner',
    'region',
    'pool',
    'didRange',
    'nonChargable',
    'chargePrice',
    'callForwardTarget'
  ]);
  return DIDAllocation()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..owner = const ERCustomerConverter().fromJson(json['owner'] as String)
    ..region = const ERRegionConverter().fromJson(json['region'] as String)
    ..pool = const ERDIDPoolConverter().fromJson(json['pool'] as String)
    ..didRange = json['didRange'] == null ? null : DIDRange.fromJson(json['didRange'] as Map<String, dynamic>)
    ..nonChargable = json['nonChargable'] as bool
    ..chargePrice = const MoneyConverter().fromJson(json['chargePrice'] as String)
    ..callForwardTarget = const ERCallForwardTargetConverter().fromJson(json['callForwardTarget'] as String);
}

Map<String, dynamic> _$DIDAllocationToJson(DIDAllocation instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'owner': const ERCustomerConverter().toJson(instance.owner),
      'region': const ERRegionConverter().toJson(instance.region),
      'pool': const ERDIDPoolConverter().toJson(instance.pool),
      'didRange': instance.didRange,
      'nonChargable': instance.nonChargable,
      'chargePrice': const MoneyConverter().toJson(instance.chargePrice),
      'callForwardTarget': const ERCallForwardTargetConverter().toJson(instance.callForwardTarget),
    };
