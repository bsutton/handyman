// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'apiKey',
    'username',
    'firstname',
    'surname',
    'description',
    'password',
    'fireStoreUserToken',
    'emailAddress',
    'landline',
    'mobilePhone',
    'extensionNo',
    'userRole',
    'owner',
    'voicemailBox',
    'enabled'
  ]);
  return User(
    enabled: json['enabled'] as bool,
    owner: const ERCustomerConverter().fromJson(json['owner'] as String),
    userRole: _$enumDecodeNullable(_$UserRoleEnumMap, json['userRole']),
    apiKey: json['apiKey'] as String,
    username: json['username'] as String,
    emailAddress: const EmailAddressConverter().fromJson(json['emailAddress'] as String),
    description: json['description'] as String,
    firstname: json['firstname'] as String,
    surname: json['surname'] as String,
    mobilePhone: const PhoneNumberConverter().fromJson(json['mobilePhone'] as String),
  )
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..password = json['password'] as String
    ..fireStoreUserToken = json['fireStoreUserToken'] as String
    ..landline = const PhoneNumberConverter().fromJson(json['landline'] as String)
    ..extensionNo = json['extensionNo'] as String
    ..voicemailBox = const ERConvererVoicemailBox().fromJson(json['voicemailBox'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'apiKey': instance.apiKey,
      'username': instance.username,
      'firstname': instance.firstname,
      'surname': instance.surname,
      'description': instance.description,
      'password': instance.password,
      'fireStoreUserToken': instance.fireStoreUserToken,
      'emailAddress': const EmailAddressConverter().toJson(instance.emailAddress),
      'landline': const PhoneNumberConverter().toJson(instance.landline),
      'mobilePhone': const PhoneNumberConverter().toJson(instance.mobilePhone),
      'extensionNo': instance.extensionNo,
      'userRole': _$UserRoleEnumMap[instance.userRole],
      'owner': const ERCustomerConverter().toJson(instance.owner),
      'voicemailBox': const ERConvererVoicemailBox().toJson(instance.voicemailBox),
      'enabled': instance.enabled,
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

const _$UserRoleEnumMap = {
  UserRole.Staff: 'Staff',
  UserRole.Administrator: 'Administrator',
  UserRole.Accounts: 'Accounts',
  UserRole.Provider: 'Provider',
  UserRole.CustomerAdministrator: 'CustomerAdministrator',
  UserRole.CustomerStaff: 'CustomerStaff',
  UserRole.All: 'All',
  UserRole.Monitor: 'Monitor',
};
