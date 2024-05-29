// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      username: json['username'] as String,
      enabled: json['enabled'] as bool? ?? true,
      owner: _$JsonConverterFromJson<String, ER<Customer>>(
          json['owner'], const ERConverterCustomer().fromJson),
      userRole: $enumDecodeNullable(_$UserRoleEnumMap, json['userRole']) ??
          UserRole.customerStaff,
      apiKey: json['apiKey'] as String?,
      emailAddress: _$JsonConverterFromJson<String, EmailAddress>(
          json['emailAddress'], const ConverterEmailAddress().fromJson),
      description: json['description'] as String?,
      firstname: json['firstname'] as String?,
      surname: json['surname'] as String?,
      mobilePhone: _$JsonConverterFromJson<String, PhoneNumber>(
          json['mobilePhone'], const ConverterPhoneNumber().fromJson),
    )
      ..id = json['id'] as int?
      ..guid = const GUIDConverter().fromJson(json['guid'])
      ..password = json['password'] as String?
      ..fireStoreUserToken = json['fireStoreUserToken'] as String?
      ..landline = _$JsonConverterFromJson<String, PhoneNumber>(
          json['landline'], const ConverterPhoneNumber().fromJson)
      ..extensionNo = json['extensionNo'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'apiKey': instance.apiKey,
      'username': instance.username,
      'firstname': instance.firstname,
      'surname': instance.surname,
      'description': instance.description,
      'password': instance.password,
      'fireStoreUserToken': instance.fireStoreUserToken,
      'emailAddress': _$JsonConverterToJson<String, EmailAddress>(
          instance.emailAddress, const ConverterEmailAddress().toJson),
      'landline': _$JsonConverterToJson<String, PhoneNumber>(
          instance.landline, const ConverterPhoneNumber().toJson),
      'mobilePhone': _$JsonConverterToJson<String, PhoneNumber>(
          instance.mobilePhone, const ConverterPhoneNumber().toJson),
      'extensionNo': instance.extensionNo,
      'userRole': _$UserRoleEnumMap[instance.userRole],
      'owner': _$JsonConverterToJson<String, ER<Customer>>(
          instance.owner, const ERConverterCustomer().toJson),
      'enabled': instance.enabled,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

const _$UserRoleEnumMap = {
  UserRole.staff: 'staff',
  UserRole.administrator: 'administrator',
  UserRole.accounts: 'accounts',
  UserRole.provider: 'provider',
  UserRole.customerAdministrator: 'customerAdministrator',
  UserRole.customerStaff: 'customerStaff',
  UserRole.all: 'all',
  UserRole.monitor: 'monitor',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
