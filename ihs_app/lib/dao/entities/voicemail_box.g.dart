// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voicemail_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoicemailBox _$VoicemailBoxFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['id', 'guid', 'customer', 'owner', 'mailboxNo', 'label', 'greeting']);
  return VoicemailBox()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..customer = const ERCustomerConverter().fromJson(json['customer'] as String)
    ..owner = const ERUserConverter().fromJson(json['owner'] as String)
    ..mailboxNo = json['mailboxNo'] as int
    ..label = json['label'] as String
    ..greeting = const ERAudioFileConverter().fromJson(json['greeting'] as String);
}

Map<String, dynamic> _$VoicemailBoxToJson(VoicemailBox instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'customer': const ERCustomerConverter().toJson(instance.customer),
      'owner': const ERUserConverter().toJson(instance.owner),
      'mailboxNo': instance.mailboxNo,
      'label': instance.label,
      'greeting': const ERAudioFileConverter().toJson(instance.greeting),
    };
