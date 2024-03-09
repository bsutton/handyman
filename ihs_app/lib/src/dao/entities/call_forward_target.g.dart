// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_forward_target.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallForwardTarget _$CallForwardTargetFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'owner',
    'forwardCallsTo',
    'externalNo',
    'messageMethod',
    'generated',
    'recording',
    'message',
    'colleague',
    'team',
    'ivr',
    'conference'
  ]);
  return CallForwardTarget()
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..owner = const ERCustomerConverter().fromJson(json['owner'] as String)
    ..forwardCallsTo =
        _$enumDecodeNullable(_$ForwardCallsToEnumMap, json['forwardCallsTo'])
    ..externalNo =
        const PhoneNumberConverter().fromJson(json['externalNo'] as String)
    ..messageMethod =
        _$enumDecodeNullable(_$MessageMethodEnumMap, json['messageMethod'])
    ..generated =
        const ERAudioFileConverter().fromJson(json['generated'] as String)
    ..recording =
        const ERAudioFileConverter().fromJson(json['recording'] as String)
    ..message = const ERAudioFileConverter().fromJson(json['message'] as String)
    ..colleague = const ERUserConverter().fromJson(json['colleague'] as String)
    ..team = const ERJobConverter().fromJson(json['team'] as String)
    ..ivr = const ERIVRConverter().fromJson(json['ivr'] as String)
    ..conference =
        const ERConverterConference().fromJson(json['conference'] as String);
}

Map<String, dynamic> _$CallForwardTargetToJson(CallForwardTarget instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'owner': const ERCustomerConverter().toJson(instance.owner),
      'forwardCallsTo': _$ForwardCallsToEnumMap[instance.forwardCallsTo],
      'externalNo': const PhoneNumberConverter().toJson(instance.externalNo),
      'messageMethod': _$MessageMethodEnumMap[instance.messageMethod],
      'generated': const ERAudioFileConverter().toJson(instance.generated),
      'recording': const ERAudioFileConverter().toJson(instance.recording),
      'message': const ERAudioFileConverter().toJson(instance.message),
      'colleague': const ERUserConverter().toJson(instance.colleague),
      'team': const ERJobConverter().toJson(instance.team),
      'ivr': const ERIVRConverter().toJson(instance.ivr),
      'conference': const ERConverterConference().toJson(instance.conference),
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

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

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

const _$ForwardCallsToEnumMap = {
  ForwardCallsTo.COLLEAGUE: 'COLLEAGUE',
  ForwardCallsTo.VOICEMAIL: 'VOICEMAIL',
  ForwardCallsTo.EXTERNAL_NO: 'EXTERNAL_NO',
  ForwardCallsTo.IVR: 'IVR',
  ForwardCallsTo.MESSAGE: 'MESSAGE',
  ForwardCallsTo.TEAM: 'TEAM',
  ForwardCallsTo.CONFERENCE: 'CONFERENCE',
};

const _$MessageMethodEnumMap = {
  MessageMethod.GENERATED: 'GENERATED',
  MessageMethod.RECORDED: 'RECORDED',
};
