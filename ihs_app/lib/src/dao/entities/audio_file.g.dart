// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioFile _$AudioFileFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'owner',
    'priority',
    'created',
    'name',
    'duration',
    'direction',
    'audio',
    'type',
    'transcriptionQueueStatus',
    'transcriptionStatus',
    'transcriptionAttempts',
    'sentimentStatus',
    'sentimentAttempts',
    'summaryStatus',
    'summaryAttempts',
    'transcription',
    'summary',
    'sentiment',
    'nextTranscriptionAttempt'
  ]);
  return AudioFile(
    _$enumDecodeNullable(_$TypeEnumMap, json['type']),
    json['duration'] == null ? null : Duration(microseconds: json['duration'] as int),
    const ByteBufferConverter().fromJson(json['audio'] as String),
  )
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..owner = const ERUserConverter().fromJson(json['owner'] as String)
    ..priority = json['priority'] as int
    ..created = json['created'] == null ? null : DateTime.parse(json['created'] as String)
    ..name = json['name'] as String
    ..direction = _$enumDecodeNullable(_$DirectionEnumMap, json['direction'])
    ..transcriptionQueueStatus =
        _$enumDecodeNullable(_$TranscriptionQueueStatusEnumMap, json['transcriptionQueueStatus'])
    ..transcriptionStatus = _$enumDecodeNullable(_$TranscriptionStatusEnumMap, json['transcriptionStatus'])
    ..transcriptionAttempts = json['transcriptionAttempts'] as int
    ..sentimentStatus = _$enumDecodeNullable(_$SentimentStatusEnumMap, json['sentimentStatus'])
    ..sentimentAttempts = json['sentimentAttempts'] as int
    ..summaryStatus = _$enumDecodeNullable(_$SummaryStatusEnumMap, json['summaryStatus'])
    ..summaryAttempts = json['summaryAttempts'] as int
    ..transcription = json['transcription'] as String
    ..summary = json['summary'] as String
    ..sentiment = _$enumDecodeNullable(_$SentimentEnumMap, json['sentiment'])
    ..nextTranscriptionAttempt =
        json['nextTranscriptionAttempt'] == null ? null : DateTime.parse(json['nextTranscriptionAttempt'] as String);
}

Map<String, dynamic> _$AudioFileToJson(AudioFile instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'owner': const ERUserConverter().toJson(instance.owner),
      'priority': instance.priority,
      'created': instance.created?.toIso8601String(),
      'name': instance.name,
      'duration': instance.duration?.inMicroseconds,
      'direction': _$DirectionEnumMap[instance.direction],
      'audio': const ByteBufferConverter().toJson(instance.audio),
      'type': _$TypeEnumMap[instance.type],
      'transcriptionQueueStatus': _$TranscriptionQueueStatusEnumMap[instance.transcriptionQueueStatus],
      'transcriptionStatus': _$TranscriptionStatusEnumMap[instance.transcriptionStatus],
      'transcriptionAttempts': instance.transcriptionAttempts,
      'sentimentStatus': _$SentimentStatusEnumMap[instance.sentimentStatus],
      'sentimentAttempts': instance.sentimentAttempts,
      'summaryStatus': _$SummaryStatusEnumMap[instance.summaryStatus],
      'summaryAttempts': instance.summaryAttempts,
      'transcription': instance.transcription,
      'summary': instance.summary,
      'sentiment': _$SentimentEnumMap[instance.sentiment],
      'nextTranscriptionAttempt': instance.nextTranscriptionAttempt?.toIso8601String(),
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

const _$TypeEnumMap = {
  Type.VOICEMAIL: 'VOICEMAIL',
  Type.RECORDING: 'RECORDING',
  Type.CUSTOM_MESSAGE: 'CUSTOM_MESSAGE',
};

const _$DirectionEnumMap = {
  Direction.TEXT_TO_SPEECH: 'TEXT_TO_SPEECH',
  Direction.SPEECH_TO_TEXT: 'SPEECH_TO_TEXT',
};

const _$TranscriptionQueueStatusEnumMap = {
  TranscriptionQueueStatus.PRE_QUEUE: 'PRE_QUEUE',
  TranscriptionQueueStatus.QUEUED: 'QUEUED',
  TranscriptionQueueStatus.FAILED: 'FAILED',
  TranscriptionQueueStatus.SUCCESS: 'SUCCESS',
};

const _$TranscriptionStatusEnumMap = {
  TranscriptionStatus.PENDING: 'PENDING',
  TranscriptionStatus.TRANSCRIBED: 'TRANSCRIBED',
};

const _$SentimentStatusEnumMap = {
  SentimentStatus.PENDING: 'PENDING',
  SentimentStatus.EXTRACTED: 'EXTRACTED',
};

const _$SummaryStatusEnumMap = {
  SummaryStatus.PENDING: 'PENDING',
  SummaryStatus.SUMMARIZED: 'SUMMARIZED',
};

const _$SentimentEnumMap = {
  Sentiment.POSITIVE: 'POSITIVE',
  Sentiment.NEUTRAL: 'NEUTRAL',
  Sentiment.NEGATIVE: 'NEGATIVE',
};
