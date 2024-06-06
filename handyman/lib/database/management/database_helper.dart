import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../versions/db_upgrade.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static late Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database get database => _database!;

  static Future<void> initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        /// required for non-mobile platforms.
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      } else if (Platform.isAndroid || Platform.isIOS) {
        /// uses the default factory.
      }
    }

    final path = await pathToDatabase();
    _database = await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
            version: await getLatestVersion(), onUpgrade: upgradeDb));
  }

  static Future<String> pathToDatabase() async {
    final path = join(await getDatabasesPath(), 'handyman.db');
    return path;
  }
}
