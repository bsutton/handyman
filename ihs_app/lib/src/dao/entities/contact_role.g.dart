// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactRole _$ContactRoleFromJson(Map<String, dynamic> json) => ContactRole()
  ..id = json['id'] as int?
  ..guid = const GUIDConverter().fromJson(json['guid'])
  ..job = Job.fromJson(json['job'] as Map<String, dynamic>)
  ..contact = Contact.fromJson(json['contact'] as Map<String, dynamic>)
  ..role = Role.fromJson(json['role'] as Map<String, dynamic>);

Map<String, dynamic> _$ContactRoleToJson(ContactRole instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'job': instance.job,
      'contact': instance.contact,
      'role': instance.role,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
