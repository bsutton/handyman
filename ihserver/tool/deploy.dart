#! /usr/bin/env dcli

import 'dart:io';

import 'package:args/args.dart';

import 'remote.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage.')
    ..addFlag('reload', negatable: false, help: 'Restart without uploading.');
  try {
    final options = parser.parse(args);
    if (options.rest.isNotEmpty) {
      throw const FormatException('Unexpected positional arguments.');
    }
    if (options['help'] as bool) {
      print('Usage: tool/deploy [--reload]\n${parser.usage}');
      return;
    }
    final remote = RemoteDeployment.load();
    if (options['reload'] as bool) {
      await remote.reload();
    } else {
      await remote.deploy();
    }
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    exitCode = 64;
  } on ProcessException catch (error) {
    stderr.writeln(error);
    exitCode = error.errorCode > 0 ? error.errorCode : 1;
  } on FileSystemException catch (error) {
    stderr.writeln(error);
    exitCode = 1;
  }
}
