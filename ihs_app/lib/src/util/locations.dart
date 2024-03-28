import 'dart:async';

import 'package:completer_ex/completer_ex.dart';
import 'package:flutter/services.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart' as tz;

import 'log.dart';

class Locations {
  factory Locations() => _self;

  Locations._internal();
  final loaded = CompleterEx<void>();

  static final Locations _self = Locations._internal();

  Future<Location> getLocation(String timezoneName) async {
    await _loadDatabase();
    return tz.getLocation(timezoneName);
  }

  Future<void> _loadDatabase() async {
    if (!loaded.isCompleted) {
      const path = 'assets/timezone/data/2019b.tzf';
      Log.d('Loading $path');
      final byteData = await rootBundle.load(path);
      Log.d('Loaded $path size: ${byteData.lengthInBytes}');
      final rawData = byteData.buffer.asUint8List().toList();
      tz.initializeDatabase(rawData);
      loaded.complete();
    }
  }
}
