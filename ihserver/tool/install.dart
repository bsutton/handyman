#! /usr/bin/env dart

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:dcli/posix.dart';
import 'package:ihserver/src/dcli/resource/generated/resource_registry.g.dart';
import 'package:ihserver/src/service_control.dart';
import 'package:ihserver/src/version/version.g.dart';
import 'package:path/path.dart';

final pathToHandyman = join(rootPath, 'opt', 'handyman');
final pathToHandymanBin = join(rootPath, 'opt', 'handyman', 'bin');

/// when deploying we copy the executable to an alternate location as the
/// existing execs will be running and therefore locked.
final pathToHandymanAltBin = join(rootPath, 'opt', 'handyman', 'altbin');
final pathToWwwRoot = join(pathToHandyman, 'www_root');
final pathToIHServer = join(pathToHandymanBin, 'ihserver');
final pathToLauncher = join(pathToHandymanBin, 'ihlaunch');
final pathToLauncherScript = join(pathToHandymanBin, 'ihlaunch.sh');

Future<void> main(List<String> args) async {
  final argParser = ArgParser()
    ..addFlag('verbose', abbr: 'v', help: 'Enable verbose deployment output.')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage.')
    ..addFlag(
      'restart',
      negatable: false,
      help: 'Restart the installed service without deploying files.',
    );
  late final ArgResults parsed;
  try {
    parsed = argParser.parse(args);
    if (parsed.rest.isNotEmpty) {
      throw const FormatException('Unexpected positional arguments.');
    }
  } on FormatException catch (error) {
    stderr
      ..writeln(error.message)
      ..writeln(argParser.usage);
    exitCode = 64;
    return;
  }
  if (parsed['help'] as bool) {
    print(
      'Usage: install [--restart] [--verbose]\n'
      'With no options, install and restart ihserver.\n${argParser.usage}',
    );
    return;
  }
  if (parsed['restart'] as bool) {
    if (!Shell.current.isPrivilegedProcess) {
      stderr.writeln('Run sudo ./install --restart');
      exitCode = 1;
      return;
    }
    await restartService();
    print('Service restart requested. Check /var/log/ihserver.log.');
    return;
  }

  Settings().setVerbose(enabled: parsed['verbose'] as bool);

  print('Deploying: ihserver $packageVersion');

  _createDirectory(pathToWwwRoot);

  await Shell.current.withPrivilegesAsync(() async {
    print(green('unpacking resources to: $pathToHandyman'));

    await stopService();
    unpackResources(pathToHandyman);

    /// Create the dir to store letsencrypt files
    final pathToLetsEncrypt = join(pathToHandyman, 'letsencrypt', 'live');
    _createDir(pathToLetsEncrypt);

    _addCronBoot(pathToLauncherScript);

    // restart t
    await _restart();
  });
}

/// Restart the the ihserver by killing the existing processes
/// and spawning them detached.
Future<void> _restart() async {
  // on first time install the bin directory won't exist.
  if (!exists(pathToHandymanBin)) {
    createDir(pathToHandymanBin, recursive: true);
  }

  /// we can't copy over running exe but we can deleted it.
  deleteDir(pathToHandymanBin);
  createDir(pathToHandymanBin);
  copyTree(pathToHandymanAltBin, pathToHandymanBin, overwrite: true);

  // set execute priviliged
  makeExecutable(pathToIHServer, pathToLauncher, pathToLauncherScript);

  await startService();
  print(green('Deployment complete; service restart requested.'));
  print('Check /var/log/ihserver.log for startup status.');
}

void makeExecutable(
  String pathToIHServer,
  String pathToLauncher,
  String pathToLauncherScript,
) {
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
