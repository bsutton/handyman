// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'did_forward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DIDForward _$DIDForwardFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['id', 'guid', 'owner', 'did', 'allocation', 'callForwardTarget']);
  return DIDForward()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..owner = const ERCustomerConverter().fromJson(json['owner'] as String)
    ..did = const PhoneNumberConverter().fromJson(json['did'] as String)
    ..allocation = const ERDIDAllocationConverter().fromJson(json['allocation'] as String)
    ..callForwardTarget = const ERCallForwardTargetConverter().fromJson(json['callForwardTarget'] as String);
}

Map<String, dynamic> _$DIDForwardToJson(DIDForward instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'owner': const ERCustomerConverter().toJson(instance.owner),
      'did': const PhoneNumberConverter().toJson(instance.did),
      'allocation': const ERDIDAllocationConverter().toJson(instance.allocation),
      'callForwardTarget': const ERCallForwardTargetConverter().toJson(instance.callForwardTarget),
    };
