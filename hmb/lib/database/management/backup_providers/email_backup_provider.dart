import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dcli_core/dcli_core.dart';

import '../database_helper.dart';

abstract class BackupProvider {
  /// Returns tthe path to where the file was stored.
  // TODO(bsutton): this should be a uri
  Future<BackupResult> store(
      {required String pathToDatabase,
      required String pathToZippedBackup,
      required int version});

  /// Retrieve a list of prior backups made by the backup provider.
  Future<List<String>> getBackups();

  /// Retrieve a specific backup made by the backup provider.
  Future<Backup> getBackup(String pathTo);

  /// Delete a specific backup made by the backup provider.
  /// The pathTo is the path to the backup file on the providers
  /// system.
  Future<void> deleteBackup(Backup backupToDelete);

  Future<BackupResult> performBackup({required int version}) async {
    final encoder = ZipFileEncoder();

    return withTempFileAsync((pathToZip) async {
      encoder.create(pathToZip);
      final wasOpen = DatabaseHelper().isOpen();

      if (wasOpen) {
        await DatabaseHelper().closeDb();
      }
      final pathToDatabase = await DatabaseHelper().pathToDatabase();
      await encoder.addFile(File(pathToDatabase));
      await encoder.close();

      if (wasOpen) {
        await DatabaseHelper().openDb();
      }
      //after that some of code for making the zip files
      return store(
          pathToZippedBackup: pathToZip,
          pathToDatabase: pathToDatabase,
          version: version);
    }, suffix: 'zip');
  }
}

class BackupResult {
  BackupResult(
      {required this.pathToSource,
      required this.pathToBackup,
      required this.success}) {
    if (!exists(pathToBackup)) {
      success = false;
      status = 'Backup failed. Backup file not found.';
    } else {
      success = true;
      sourceSize = stat(pathToSource).size;
      backupSize = stat(pathToBackup).size;
    }
  }
  String pathToSource;
  String pathToBackup;
  bool success;

  late int sourceSize;
  late int backupSize;
  late String status;

  @override
  String toString() {
    final sb = StringBuffer();
    if (success) {
      sb.write('Database backup completed successfully.');
    }
    sb
      ..write('Source: $pathToSource')
      ..write('To: $pathToBackup')
      ..write('Original Size: $sourceSize')
      ..write('Backuped Size: $backupSize');
    return sb.toString();
  }
}

class Backup {
  Backup(
      {required this.when,
      required this.pathTo,
      required this.size,
      required this.status,
      required this.error});
  DateTime when;
  String pathTo;
  String size;
  String status;
  String error;
}