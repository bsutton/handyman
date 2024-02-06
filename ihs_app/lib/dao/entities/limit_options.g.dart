// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'limit_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LimitOption _$LimitOptionFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['id', 'guid', 'description', 'cost', 'quantity']);
  return LimitOption(
    json['description'] as String,
    const MoneyConverter().fromJson(json['cost'] as String),
    json['quantity'] as int,
  )
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid']);
}

Map<String, dynamic> _$LimitOptionToJson(LimitOption instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'description': instance.description,
      'cost': const MoneyConverter().toJson(instance.cost),
      'quantity': instance.quantity,
    };
