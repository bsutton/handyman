#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'package:settings_yaml/settings_yaml.dart';

void main(List<String> args) {
  // 'dcli pack'.run;
  // 'zip -r www_root.zip www_root'.run;

  print(green('Compiling ihserver'));
  final project = DartProject.self;
  DartScript.fromFile(join('bin', 'ihserver.dart'), project: project)
      .compile(overwrite: true);

  print(green('Compiling launch'));
  DartScript.fromFile(join('bin', 'ihlaunch.dart'), project: project)
      .compile(overwrite: true);

  print(green('Packing static resources under ${truepath('www_root')}'));
  Resources().pack();

  final buildSettings = SettingsYaml.load(
      pathToSettings: join(project.pathToProjectRoot, 'tool', 'build.yaml'));

  final scpCommand = buildSettings.asString('scp_command');
  final targetServer = buildSettings.asString('target_server');
  final targetDirectory = buildSettings.asString('target_directory');

  /// Order is important.
  /// We must compile iahserver and the resources as they are all
  /// compiled into the deploy script.

  print(green('Compiling tool/deploy.dart'));
  DartScript.fromFile(join('tool', 'deploy.dart'), project: project)
      .compile(overwrite: true);

  print(green("deploying 'deploy' to $targetDirectory"));
  '$scpCommand tool/deploy $targetServer:$targetDirectory'.run;

  print(orange('build/deploy complete'));
  print("log into the $targetServer and run 'sudo ./deploy'");
}
