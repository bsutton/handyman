#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:dcli/posix.dart';
import 'package:ihserver/src/dcli/resource/generated/resource_registry.g.dart';
import 'package:path/path.dart';

void main(List<String> args) {
  final pathToHandyman = join(rootPath, 'opt', 'handyman');
  final pathToWwwRoot = join(pathToHandyman, 'www_root');
  final pathToIHServer = join(pathToHandyman, 'bin', 'ihserver');
  final pathToLauncher = join(pathToHandyman, 'bin', 'launch');

  _createDirectory(pathToWwwRoot);

  Shell.current.withPrivileges(() {
    print(green('unpacking resouces to: $pathToHandyman'));
    for (final resource in ResourceRegistry.resources.values) {
      final localPathTo = join(pathToHandyman, resource.originalPath);
      final resourceDir = dirname(localPathTo);
      _createDir(resourceDir);
      print('Unpacking $localPathTo');
      resource.unpack(localPathTo);
    }

    // set execute priviliged
    chmod(pathToIHServer, permission: '710');

    /// Create the dir to store letsencrypt files
    final pathToLetsEncrypt = join(pathToHandyman, 'letsencrypt', 'live');
    _createDir(pathToLetsEncrypt);

    _addCronBoot(pathToLauncher);
  });

  // 'dcli pack'.run;
//   'unzip -d $pathToHandyman www_root.zip www_root'.run;
}

/// Add cron job so we get rebooted each time the system is rebooted.
void _addCronBoot(String pathToLauncher) {
  print(green('Adding cronjob to restart ihserver on reboot'));
  join(rootPath, 'etc', 'cron.d', 'ihserver').write('''
@reboot $pathToLauncher
''');

  // ('(crontab -l ; echo "@reboot $pathToIHServer")' | 'crontab -').run;
}

void _createDir(String pathToDir) {
  if (!exists(pathToDir)) {
    createDir(pathToDir, recursive: true);
  }
}

void _createDirectory(String pathToWwwRoot) {
  if (!Shell.current.isPrivilegedUser) {
    printerr(red('You must run this script as sudo'));
    exit(1);
  }

  Shell.current.releasePrivileges();

  Shell.current.withPrivileges(() {
    if (exists(pathToWwwRoot)) {
      deleteDir(pathToWwwRoot);
    }
    createDir(pathToWwwRoot, recursive: true);

    chown(pathToWwwRoot, user: 'bsutton', group: 'bsutton');
  });
}
