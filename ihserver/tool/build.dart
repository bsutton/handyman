#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

void main(List<String> args) {
  // 'dcli pack'.run;
  // 'zip -r www_root.zip www_root'.run;

  print(green('Compiling ihserver'));
  final project = DartProject.self;
  DartScript.fromFile(join('bin', 'ihserver.dart'), project: project)
      .compile(overwrite: true);

  print(green('Compiling launch'));
  DartScript.fromFile(join('bin', 'launch.dart'), project: project)
      .compile(overwrite: true);

  print(green('Packing static resources under ${truepath('www_root')}'));
  Resources().pack();

  /// Order is important.
  /// We must compile iahserver and the resources as they are all
  /// compiled into the deploy script.

  print(green('Compiling tool/deploy.dart'));
  DartScript.fromFile(join('tool', 'deploy.dart'), project: project)
      .compile(overwrite: true);

  print(green("deploying 'deploy' to /opt/handyman"));
  'op-scp tool/deploy handyman:/opt/handyman'.run;

  print(orange('build/deploy complete'));
  print("log into the handyman server and run 'sudo ./deploy'");
}
