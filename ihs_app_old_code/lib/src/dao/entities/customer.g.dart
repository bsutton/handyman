// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer()
  ..id = json['id'] as int?
  ..guid = const GUIDConverter().fromJson(json['guid'])
  ..primaryContact =
      const ERConverterUser().fromJson(json['primaryContact'] as String)
  ..name = json['name'] as String
  ..createdDate =
      const LocalDateConverter().fromJson(json['createdDate'] as String);

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'guid': _$JsonConverterToJson<dynamic, GUID>(
          instance.guid, const GUIDConverter().toJson),
      'primaryContact': const ERConverterUser().toJson(instance.primaryContact),
      'name': instance.name,
      'createdDate': const LocalDateConverter().toJson(instance.createdDate),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
