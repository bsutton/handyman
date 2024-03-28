import 'dart:io';

import 'package:path/path.dart';

import '../dao/types/guid.dart';

enum TempFileLocations { recordings }

class FileUtils {
  factory FileUtils() {
    _self ??= FileUtils._internal();
    return _self!;
  }

  FileUtils._internal() {
    // _mfs = MemoryFileSystem(style: FileSystemStyle.posix);
  }
  static FileUtils? _self;
  static const String _rootDir = 'square_phone';

  ///
  /// Creates a temporary file in the systems temp directory.
  /// [location] is the directory (under the temp file system) to place the file in.
  /// [prefix] is an optional prefix to prepend to the randomly generated filename.
  ///
  /// You are responsible for deleting the file once you have finished with it.
  ///
  /// Example:
  /// ```dart
  /// File tmpRecording = await TempFiles().create(TempFileLocations.RECORDINGS);
  /// ```
  ///
  String createTempFile(TempFileLocations location, [String prefix = '']) {
    final derivedPath = join(
      Directory.systemTemp.path,
      _rootDir,
      location.toString().split('.').last,
    );

    final directory = Directory(derivedPath)..createSync(recursive: true);

    // make certain we have a random filename that doesn't already exist.
    String path;
    do {
      final fileName = prefix + generateRandomFileName();
      path = join(directory.path, fileName);
    } while (File(path).existsSync());

    final tmpFile = File(path)..createSync();

    return tmpFile.path;
  }

  String generateRandomFileName() => GUID.generate().toString();

  bool exists(String path) => File(path).existsSync();
}
