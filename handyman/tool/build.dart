#! /home/bsutton/.dswitch/active/dart

import 'dart:convert';
import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

void main() {
  final pathToAssets = join(
      DartProject.self.pathToProjectRoot, 'assets', 'sql', 'upgrade_scripts');
  final assetFiles = find('v*.sql', workingDirectory: pathToAssets).toList();

  final relativePaths = assetFiles
      .map((path) => relative(path, from: DartProject.self.pathToProjectRoot))
      .toList();

  final jsonContent = jsonEncode(relativePaths);
  final jsonFile = File('assets/sql/upgrade_list.json')
    ..writeAsStringSync(jsonContent);

  print('SQL Asset list generated: ${jsonFile.path}');
}
