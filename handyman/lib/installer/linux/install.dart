import 'dart:io';

import 'package:flutter/services.dart';
import 'package:halfpipe/halfpipe.dart';

Future<void> linuxInstaller() async {
  await _installDeepLinkHander();
}

Future<void> _installDeepLinkHander() async {
  final desktopLauncher =
      await rootBundle.loadString('assets/installer/linux/hmb.desktop');
  const pathTo = '/usr/share/applications/hmb.desktop';
  await File(pathTo).writeAsString(desktopLauncher);

  /// Force a db update.
  await HalfPipe().command('update-desktop-database $pathTo').exitCode();
}
