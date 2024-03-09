// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'primaryContact',
    'name',
    'startDate',
    'suspensionDate',
    'ownedPhoneNumbers',
    'officeHolidays',
    'region',
    'trialExpiryDate'
  ]);
  return Customer()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..primaryContact = const ERUserConverter().fromJson(json['primaryContact'] as String)
    ..name = json['name'] as String
    ..startDate = const LocalDateConverter().fromJson(json['startDate'] as String)
    ..suspensionDate = const LocalDateConverter().fromJson(json['suspensionDate'] as String)
    ..ownedPhoneNumbers = (json['ownedPhoneNumbers'] as List)
        ?.map((dynamic e) => const ERConverterDIDForward().fromJson(e as String))
        ?.toList()
    ..officeHolidays = const ERConverterOficeHolidays().fromJson(json['officeHolidays'] as String)
    ..region = const ERRegionConverter().fromJson(json['region'] as String)
    ..trialExpiryDate = const LocalDateConverter().fromJson(json['trialExpiryDate'] as String);
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'primaryContact': const ERUserConverter().toJson(instance.primaryContact),
      'name': instance.name,
      'startDate': const LocalDateConverter().toJson(instance.startDate),
      'suspensionDate': const LocalDateConverter().toJson(instance.suspensionDate),
      'ownedPhoneNumbers': instance.ownedPhoneNumbers?.map(const ERConverterDIDForward().toJson)?.toList(),
      'officeHolidays': const ERConverterOficeHolidays().toJson(instance.officeHolidays),
      'region': const ERRegionConverter().toJson(instance.region),
      'trialExpiryDate': const LocalDateConverter().toJson(instance.trialExpiryDate),
    };
