import 'dart:io';

import 'package:date_time_format/date_time_format.dart';

Future<void> backupDatabase(String pathToDatabase,
    {required int version}) async {
  final datePart =
      DateTimeFormat.format(DateTime.now(), format: 'Y.j.d.H.i.s');

  /// db file path with .bak and date/time/added
  final backupPath =
      '$pathToDatabase.$version.$datePart.bak';

  final dbFile = File(pathToDatabase);
  final backupFile = File(backupPath);

  if (dbFile.existsSync()) {
    await backupFile.writeAsBytes(await dbFile.readAsBytes());
    print('''
Database backup completed successfully: 
  Original Size: ${dbFile.lengthSync()}
  Backuped Size: ${backupFile.lengthSync()}
        ''');
  } else {
    print('Database file not found.');
  }
}
