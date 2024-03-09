import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:completer_ex/completer_ex.dart';

import '../util/file_utils.dart';
import '../util/log.dart';

// ignore: constant_identifier_names
enum RecordingStorage { URL, FILE, BUFFER }

/// Takes a URL or a byte buffer and stores it into a temporary file so that
/// it can be played back.
/// YOU MUST call dispose on this object to ensure the temporary
/// file is removed.
class AudioMedia {
  /// Creates an empty AudioMedia object that you can record into.
  AudioMedia.empty()
      : duration = Duration.zero,
        storageType = RecordingStorage.FILE {
    final file = _createTempFile();
    _tempStoragePath = file;

    Log.d('AudioMedia.empty created file $_tempStoragePath')
        .d('storage exists = ${FileUtils().exists(_tempStoragePath!)}');

    stored.complete();
  }

  AudioMedia.fromURL(this.url, {this.duration = Duration.zero})
      : storageType = RecordingStorage.URL;

  AudioMedia.fromBuffer(this.buffer, {this.duration = Duration.zero})
      : storageType = RecordingStorage.BUFFER {
    final file = _createTempFile();
    _tempStoragePath = file;
    File(_tempStoragePath!).writeAsBytesSync(buffer!);
    stored.complete();
  }
  RecordingStorage storageType;
  // depending on the storageType one of the following two will contain a value.
  String? _tempStoragePath;
  String? url;

  /// If [AudioMedia.fromBuffer] was called then this contains the buffered
  /// data.
  Uint8List? buffer;

  Duration duration;

  bool cleanupRequired = false;

  CompleterEx<void> stored = CompleterEx<void>();

  Future<String> get path async {
    await stored.future;
    return Future.value(_tempStoragePath);
  }

  // void _storeBuffer(Uint8List buffer) {
  //   Future<File> tmp = _createTempFile();

  //   tmp.then((tmpFile) {
  //     _tempStorage = tmpFile;

  //     if (buffer != null) {
  //       Future<File> writing = _tempStorage.writeAsBytes(buffer);
  //       // wait for the write to complete.
  //       writing.then((_) => stored.complete(true));
  //     }
  //   });
  // }

  String _createTempFile() {
    final tmpRecording =
        FileUtils().createTempFile(TempFileLocations.RECORDINGS);

    cleanupRequired = true;

    return tmpRecording;
  }

  /// This MUST be called to remove the temporary recording.
  Future<void> dispose() async {
    if (cleanupRequired) {
      cleanupRequired = false;
      if (_tempStoragePath != null) {
        await stored.future
            .then<void>((_) => File(_tempStoragePath!).deleteSync());
      }
    }
  }

  bool isEmpty() => duration == Duration.zero;

  /// If the [AudioMedia] was created from a path
  /// you can use the [load] method to read the file
  /// into the [buffer].
  void load() {
    assert(buffer == null, 'The media is in memory');
    assert(storageType == RecordingStorage.FILE, "The media isn't a File");

    buffer = File(_tempStoragePath!).readAsBytesSync();
  }
}
