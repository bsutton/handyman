// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$CallerDetailsFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'firstname',
    'surname',
    'company',
    'mobile',
    'landline'
  ]);
  return Contact()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..firstname = json['firstname'] as String
    ..surname = json['surname'] as String
    ..company = json['company'] as String
    ..mobile = const PhoneNumberConverter().fromJson(json['mobile'] as String)
    ..landline =
        const PhoneNumberConverter().fromJson(json['landline'] as String);
}

Map<String, dynamic> _$CallerDetailsToJson(Contact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'firstname': instance.firstname,
      'surname': instance.surname,
      'company': instance.company,
      'mobile': const PhoneNumberConverter().toJson(instance.mobile),
      'landline': const PhoneNumberConverter().toJson(instance.landline),
    };
