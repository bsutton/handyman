import 'dart:io';

import 'package:path/path.dart' as path;

/// A daily log retaining today and the previous 29 calendar days.
/// Rotation and pruning happen on the first write of each day (or restart).
class RotatingLog {
  RotatingLog(this.filename, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final String filename;
  final DateTime Function() _now;
  DateTime? _lastPruned;

  void append(String message) {
    // The launcher and server share this lock, which survives log renames.
    final lock = File('$filename.lock').openSync(mode: FileMode.append);
    try {
      lock.lockSync(FileLock.blockingExclusive);
      final today = _day(_now());
      final file = File(filename);
      if (file.existsSync()) {
        final modified = _day(file.lastModifiedSync());
        if (modified.isBefore(today)) {
          final archive = File('$filename.${_stamp(modified)}');
          if (archive.existsSync()) {
            // Preserve both files if an older log was restored after rotation.
            final output = archive.openSync(mode: FileMode.append);
            final input = file.openSync();
            try {
              for (
                var bytes = input.readSync(65536);
                bytes.isNotEmpty;
                bytes = input.readSync(65536)
              ) {
                output.writeFromSync(bytes);
              }
            } finally {
              input.closeSync();
              output.closeSync();
            }
            file.deleteSync();
          } else {
            file.renameSync(archive.path);
          }
        }
      }
      if (_lastPruned != today) {
        _prune(today);
        _lastPruned = today;
      }
      file.writeAsStringSync('$message\n', mode: FileMode.append);
    } finally {
      // Closing also releases the advisory lock.
      lock.closeSync();
    }
  }

  void _prune(DateTime today) {
    final cutoff = DateTime(today.year, today.month, today.day - 29);
    final pattern = RegExp(
      '^${RegExp.escape(path.basename(filename))}'
      r'\.(\d{4}-\d{2}-\d{2})$',
    );
    for (final entry in File(filename).parent.listSync(followLinks: false)) {
      if (entry is! File) {
        continue;
      }
      final match = pattern.firstMatch(path.basename(entry.path));
      if (match == null) {
        continue;
      }
      final date = DateTime.tryParse(match[1]!);
      if (date != null && _stamp(date) == match[1] && date.isBefore(cutoff)) {
        entry.deleteSync();
      }
    }
  }

  static DateTime _day(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static String _stamp(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
