#! /usr/bin/env dart

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

import 'remote.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag('local', negatable: false, help: 'Build without deploying.')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage.');
  final options = parser.parse(args);
  if (options.rest.isNotEmpty) {
    stderr.writeln('Unexpected positional arguments.');
    exitCode = 64;
    return;
  }
  if (options['help'] as bool) {
    print('Usage: dart run tool/build.dart [--local]\n${parser.usage}');
    return;
  }

  print(green('Compiling ihserver'));
  Directory.current = projectRoot;
  buildBundle('bin/ihserver.dart', 'build/server');

  print(green('Compiling launch'));
  buildBundle('bin/ihlaunch.dart', 'build/launcher');

  print(green('Packing static resources under ${truepath('www_root')}'));
  Resources().pack();

  // Pack the compiled binaries before building the installer that embeds them.

  print(green('Compiling server installer'));
  buildBundle('tool/install.dart', 'build/install');

  if (options['local'] as bool) {
    print(green('Local build complete: build/install/bundle'));
    return;
  }

  try {
    await RemoteDeployment.load().deploy();
  } on ProcessException catch (error) {
    stderr.writeln(error);
    exitCode = error.errorCode > 0 ? error.errorCode : 1;
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    exitCode = 1;
  }
}

/// Native assets require a CLI bundle rather than `dart compile exe`.
void buildBundle(String target, String output) {
  final result = Process.runSync('dart', [
    'build',
    'cli',
    '--target',
    target,
    '--output',
    output,
  ]);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(result.exitCode);
  }
  stdout.write(result.stdout);
}
