// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact()
  ..id = json['id'] as int?
  ..guid = const GUIDConverter().fromJson(json['guid'])
  ..firstname = json['firstname'] as String
  ..surname = json['surname'] as String
  ..address = Address.fromJson(json['address'] as Map<String, dynamic>)
  ..customer = Customer.fromJson(json['customer'] as Map<String, dynamic>)
  ..email = json['email'] as String?
  ..mobile = _$JsonConverterFromJson<String, PhoneNumber>(
      json['mobile'], const ConverterPhoneNumber().fromJson);

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'firstname': instance.firstname,
      'surname': instance.surname,
      'address': instance.address,
      'customer': instance.customer,
      'email': instance.email,
      'mobile': _$JsonConverterToJson<String, PhoneNumber>(
          instance.mobile, const ConverterPhoneNumber().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
