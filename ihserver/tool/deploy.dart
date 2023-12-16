#! /usr/bin/env dcli

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:dcli/posix.dart';
import 'package:ihserver/src/dcli/resource/generated/resource_registry.g.dart';
import 'package:path/path.dart';

final pathToHandyman = join(rootPath, 'opt', 'handyman');
final pathToHandymanBin = join(rootPath, 'opt', 'handyman', 'bin');

/// when deploying we copy the executabler to an alternate location as the
/// existing execs will be running and therefore locked.
final pathToHandymanAltBin = join(rootPath, 'opt', 'handyman', 'altbin');
final pathToWwwRoot = join(pathToHandyman, 'www_root');
final pathToIHServer = join(pathToHandymanBin, 'ihserver');
final pathToLauncher = join(pathToHandymanBin, 'ihlaunch');
final pathToLauncherScript = join(pathToHandymanBin, 'ihlaunch.sh');

void main(List<String> args) {
  final argParser = ArgParser()..addFlag('verbose', abbr: 'v');
  final parsed = argParser.parse(args);

  Settings().setVerbose(enabled: parsed['verbose'] as bool);

  _createDirectory(pathToWwwRoot);

  Shell.current.withPrivileges(() {
    print(green('unpacking resouces to: $pathToHandyman'));

    unpackResources(pathToHandyman);

    /// Create the dir to store letsencrypt files
    final pathToLetsEncrypt = join(pathToHandyman, 'letsencrypt', 'live');
    _createDir(pathToLetsEncrypt);

    _addCronBoot(pathToLauncherScript);

    // restart t
    _restart();
  });
}

/// Restart the the ihserver by killing the existing processes
/// and spawning them detached.
void _restart() {
  _killProcess('ihlaunch.sh');
  _killProcess('dart:ihlaunch');
  _killProcess('dart:ihserver');

  copyTree(pathToHandymanAltBin, pathToHandymanBin, overwrite: true);

  // set execute priviliged
  makeExecutable(pathToIHServer, pathToLauncher, pathToLauncherScript);

  pathToLauncherScript.start(detached: true);
}

void _killProcess(String processName) {
  final processes = ProcessHelper().getProcessesByName(processName);
  for (final process in processes) {
    'kill -9 ${process.pid}'.run;
  }
}

void makeExecutable(
    String pathToIHServer, String pathToLauncher, String pathToLauncherScript) {
  // set execute priviliged
  chmod(pathToIHServer, permission: '710');
  chmod(pathToLauncher, permission: '710');
  chmod(pathToLauncherScript, permission: '710');
}

void unpackResources(String pathToHandyman) {
  for (final resource in ResourceRegistry.resources.values) {
    final localPathTo = join(pathToHandyman, resource.originalPath);
    final resourceDir = dirname(localPathTo);
    _createDir(resourceDir);

    resource.unpack(localPathTo);
  }
}

/// Add cron job so we get rebooted each time the system is rebooted.
void _addCronBoot(String pathToLauncher) {
  print(green('Adding cronjob to restart ihserver on reboot'));
  join(rootPath, 'etc', 'cron.d', 'ihserver').write('''
@reboot root $pathToLauncher
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
