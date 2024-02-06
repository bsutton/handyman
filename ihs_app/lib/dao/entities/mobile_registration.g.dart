// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileRegistration _$MobileRegistrationFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'firstname',
    'surname',
    'region',
    'mobile',
    'status',
    'registrationExpiryDate',
    'trialBusinessNo',
    'registrationStartDate'
  ]);
  return MobileRegistration()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..firstname = json['firstname'] as String
    ..surname = json['surname'] as String
    ..region = const ERRegionConverter().fromJson(json['region'] as String)
    ..mobile = const PhoneNumberConverter().fromJson(json['mobile'] as String)
    ..status = _$enumDecodeNullable(_$MobileRegistrationStatusEnumMap, json['status'])
    ..registrationExpiryDate = const LocalDateConverter().fromJson(json['registrationExpiryDate'] as String)
    ..trialBusinessNo = const PhoneNumberConverter().fromJson(json['trialBusinessNo'] as String)
    ..registrationStartDate = const LocalDateConverter().fromJson(json['registrationStartDate'] as String);
}

Map<String, dynamic> _$MobileRegistrationToJson(MobileRegistration instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'firstname': instance.firstname,
      'surname': instance.surname,
      'region': const ERRegionConverter().toJson(instance.region),
      'mobile': const PhoneNumberConverter().toJson(instance.mobile),
      'status': _$MobileRegistrationStatusEnumMap[instance.status],
      'registrationExpiryDate': const LocalDateConverter().toJson(instance.registrationExpiryDate),
      'trialBusinessNo': const PhoneNumberConverter().toJson(instance.trialBusinessNo),
      'registrationStartDate': const LocalDateConverter().toJson(instance.registrationStartDate),
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

const _$MobileRegistrationStatusEnumMap = {
  MobileRegistrationStatus.STARTED: 'STARTED',
  MobileRegistrationStatus.REMINDER_DUE: 'REMINDER_DUE',
  MobileRegistrationStatus.ABANDONED: 'ABANDONED',
  MobileRegistrationStatus.COMPLETE: 'COMPLETE',
  MobileRegistrationStatus.SUBSCRIBED: 'SUBSCRIBED',
};
