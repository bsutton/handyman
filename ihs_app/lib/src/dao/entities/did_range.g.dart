// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'did_range.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DIDRange _$DIDRangeFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['startOfDIDRange', 'endOfDIDRange', 'dateAllocated', 'dateReleased']);
  return DIDRange()
    ..startOfDIDRange = const PhoneNumberConverter().fromJson(json['startOfDIDRange'] as String)
    ..endOfDIDRange = const PhoneNumberConverter().fromJson(json['endOfDIDRange'] as String)
    ..dateAllocated = const LocalDateConverter().fromJson(json['dateAllocated'] as String)
    ..dateReleased = const LocalDateConverter().fromJson(json['dateReleased'] as String);
}

Map<String, dynamic> _$DIDRangeToJson(DIDRange instance) => <String, dynamic>{
      'startOfDIDRange': const PhoneNumberConverter().toJson(instance.startOfDIDRange),
      'endOfDIDRange': const PhoneNumberConverter().toJson(instance.endOfDIDRange),
      'dateAllocated': const LocalDateConverter().toJson(instance.dateAllocated),
      'dateReleased': const LocalDateConverter().toJson(instance.dateReleased),
    };
