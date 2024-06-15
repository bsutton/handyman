abstract class BackupProvider {
  /// the backup provider must call [start] when it is ready to
  /// to backup the file.
  /// The start commands returns the path to the file that needs to
  /// be backed up.
  String start();

  /// the backup provider must call [done] when it has completed
  /// backing up the file.
  void done();

  /// Retrieve a list of prior backups made by the backup provider.
  Future<List<Backup>> getBackups();

  /// Retrieve a specific backup made by the backup provider.
  Future<Backup> getBackup(String pathTo);

  /// Delete a specific backup made by the backup provider.
  /// The pathTo is the path to the backup file on the providers
  /// system.
  Future<void> deleteBackup(Backup backupToDelete);
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
