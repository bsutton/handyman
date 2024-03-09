import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';
import '../../util/format.dart';
import '../../util/log.dart';
import '../../widgets/audio_media.dart';
import '../types/byte_buffer_converter.dart';
import '../types/er.dart';
import 'entity.dart';
import 'user.dart';

part 'audio_file.g.dart';

enum Type { VOICEMAIL, RECORDING, CUSTOM_MESSAGE }

enum Direction { TEXT_TO_SPEECH, SPEECH_TO_TEXT }

enum TranscriptionQueueStatus {
  PRE_QUEUE // an initial transcription attempt is underway.
  ,
  QUEUED // initial transcription failed so no awaiting an retry.
  ,
  FAILED // multiple transcription attempts failed an no further attempts will be made.
  ,
  SUCCESS // The audio is been successfully transcribed.

}

enum TranscriptionStatus { PENDING, TRANSCRIBED }

enum SentimentStatus { PENDING, EXTRACTED }

enum SummaryStatus { PENDING, SUMMARIZED }

enum Sentiment { POSITIVE, NEUTRAL, NEGATIVE }

@JsonSerializable()
class AudioFile extends Entity<AudioFile> {
  static const int MAX_ATTEMPTS = 4;

  @ERUserConverter()
  ER<User> owner;

  // Allows us to control the order we transcribe messages.
  // lower values are a higher priority
  int priority;

  DateTime created = DateTime.now();

  /// Used for the specialised buitlIn audio files which provide a set of default audio messages.
  ///
  String name;

  // Duration of the media file.
  Duration duration;

  Direction direction;

  @ByteBufferConverter()
  ByteBuffer audio;

  Type type;

  TranscriptionQueueStatus transcriptionQueueStatus =
      TranscriptionQueueStatus.PRE_QUEUE;

  TranscriptionStatus transcriptionStatus = TranscriptionStatus.PENDING;
  // no. of times we called the api in an attempt to transcribe the audio
  int transcriptionAttempts = 0;

  SentimentStatus sentimentStatus = SentimentStatus.PENDING;

  // no. of times we called the api in an attempt to extract the sentiment from the transcription
  int sentimentAttempts = 0;

  SummaryStatus summaryStatus = SummaryStatus.PENDING;
  // no. of times we called the api in an attempt to extract the summary from the transcription
  int summaryAttempts = 0;

  String transcription;

  // Summary of the transcription obtained from the Speech() api
  String summary;

  // Sentiment of the transcription obtained from the Speech() api
  Sentiment sentiment = Sentiment.NEUTRAL;

  /// When the file is queued for transcription this is the date/time when we will next try to transcribe the file.
  /// This allows to create ever bigger gaps between each attempt.
  DateTime nextTranscriptionAttempt = DateTime.now();

  /// ctor used for json deserialisation.
  AudioFile(this.type, this.duration, this.audio) {
    assert(type != null);
    direction = Direction.SPEECH_TO_TEXT;
  }

  /// create an audio file from an existing media.
  /// The media must have it's content and duration set.
  AudioFile.fromMedia(this.type, AudioMedia media) : super.forInsert() {
    assert(type != null);
    duration = media.duration;
    audio = media.buffer.buffer;
    direction = Direction.SPEECH_TO_TEXT;
  }

  /// Creates a audio file by transcribing the passed text to audio.
  /// @param type
  /// @param text

  AudioFile.text(this.type, this.transcription) : super.forInsert() {
    assert(type != null);
    direction = Direction.TEXT_TO_SPEECH;
    duration = Duration.zero;
  }

  AudioFile.namedText(this.name, this.type, this.transcription)
      : super.forInsert() {
    assert(type != null);
    direction = Direction.TEXT_TO_SPEECH;
    duration = Duration.zero;
  }

  Uint8List getAudio() {
    return audio.asUint8List();
  }

  Type getType() {
    return type;
  }

  Duration getDuration() {
    return duration;
  }

  String getFormattedDuration() {
    return Format.duration(duration);
  }

  String getName() {
    return '${type.toString().toLowerCase()}.wav';
  }

  void reQueue() {
    transcriptionStatus = TranscriptionStatus.PENDING;
  }

  String getTranscription() {
    return (transcriptionStatus == TranscriptionStatus.TRANSCRIBED
        ? transcription
        : 'Awaiting transcription ...');
  }

  Sentiment getSentiment() {
    return (sentimentStatus == SentimentStatus.EXTRACTED
        ? sentiment
        : Sentiment.NEUTRAL);
  }

  String getSummary() {
    return (summaryStatus == SummaryStatus.SUMMARIZED
        ? summary
        : 'Awaiting summary ...');
  }

  TranscriptionStatus getTranscriptionStatus() {
    return transcriptionStatus;
  }

  void setTranscription(String transcription) {
    this.transcription = transcription;

    if (this.transcription != null) {
      transcriptionStatus = TranscriptionStatus.TRANSCRIBED;
    } else {
      transcriptionStatus = TranscriptionStatus.PENDING;
    }
  }

  void setSummary(String summary) {
    this.summary = summary;
    if (this.summary != null) {
      summaryStatus = SummaryStatus.SUMMARIZED;
    } else {
      summaryStatus = SummaryStatus.PENDING;
    }
  }

  void setSentiment(Sentiment sentiment) {
    this.sentiment = sentiment;

    if (this.sentiment != null) {
      sentimentStatus = SentimentStatus.EXTRACTED;
    } else {
      sentimentStatus = SentimentStatus.PENDING;
    }
  }

  bool isTranscriptionAllowed() {
    var allowed = false;
    if (transcriptionQueueStatus != TranscriptionQueueStatus.FAILED &&
        getTranscriptionStatus() != TranscriptionStatus.TRANSCRIBED) {
      transcriptionAttempts++;

      allowed = moreAttemptsAllowed(transcriptionAttempts);
    }
    return allowed;
  }

  bool isSummaryExtractionAllowed() {
    var allowed = false;
    if (transcriptionQueueStatus != TranscriptionQueueStatus.FAILED &&
        getTranscriptionStatus() == TranscriptionStatus.TRANSCRIBED &&
        getSummaryStatus() != SummaryStatus.SUMMARIZED) {
      summaryAttempts++;

      allowed = moreAttemptsAllowed(summaryAttempts);
    }
    return allowed;
  }

  bool isSentimentExtractionAllowed() {
    var allowed = false;
    if (transcriptionQueueStatus != TranscriptionQueueStatus.FAILED &&
        getTranscriptionStatus() == TranscriptionStatus.TRANSCRIBED &&
        getSentimentStatus() != SentimentStatus.EXTRACTED) {
      sentimentAttempts++;

      allowed = moreAttemptsAllowed(sentimentAttempts);
    }
    return allowed;
  }

  /// Checks if more attempts are allowed and if not the makes the transcription as failed.
  ///
  /// @param attemptCount
  /// @return
  bool moreAttemptsAllowed(int attemptCount) {
    var allowed = true;
    if (attemptCount == MAX_ATTEMPTS) {
      Log.w('AudioFile $guid transcription FAILED.');
      transcriptionQueueStatus = TranscriptionQueueStatus.FAILED;
      allowed = false;
    }
    return allowed;
  }

  SentimentStatus getSentimentStatus() {
    return sentimentStatus;
  }

  int getSentimentAttempts() {
    return sentimentAttempts;
  }

  int getSummaryAttempts() {
    return summaryAttempts;
  }

  int getTranscriptionAttempts() {
    return transcriptionAttempts;
  }

  SummaryStatus getSummaryStatus() {
    return summaryStatus;
  }

  void markTranscriptionComplete() {
    Log.i('AudioFile $guid transcription succeeded.');
    transcriptionQueueStatus = TranscriptionQueueStatus.SUCCESS;
  }

  DateTime getCreated() {
    return created;
  }

  ///
  /// Becareful using this method!!!
  ///
  /// You MUST dispose of the AudioMedia object once you have
  /// finished with it otherwise you will leave temporary files hanging around.
  ///
  AudioMedia getMedia() {
    return AudioMedia.fromBuffer(audio.asUint8List());
  }

  factory AudioFile.fromJson(Map<String, dynamic> json) =>
      _$AudioFileFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AudioFileToJson(this);
}
