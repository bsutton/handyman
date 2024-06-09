#! /home/bsutton/.dswitch/active/dart

import 'dart:convert';
import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:handyman/database/management/db_utility.dart';
import 'package:path/path.dart';

void main() {
  final pathToAssets = join(
      DartProject.self.pathToProjectRoot, 'assets', 'sql', 'upgrade_scripts');
  final assetFiles = find('v*.sql', workingDirectory: pathToAssets).toList();

  final relativePaths = assetFiles
      .map((path) => relative(path, from: DartProject.self.pathToProjectRoot))
      .toList()

    /// sort in descending order.
    ..sort((a, b) =>
        extractVerionForSQLUpgradeScript(b) -
        extractVerionForSQLUpgradeScript(a));

  var jsonContent = jsonEncode(relativePaths);

  // make the json file more readable
  jsonContent = jsonContent.replaceAllMapped(
    RegExp(r'\[|\]'),
    (match) => match.group(0) == '[' ? '[\n  ' : '\n]',
  );
  jsonContent = jsonContent.replaceAll(RegExp(r',\s*'), ',\n  ');

  final jsonFile = File('assets/sql/upgrade_list.json')
    ..writeAsStringSync(jsonContent);

  print('SQL Asset list generated: ${jsonFile.path}');

// TODO(bsutton): the rich text editor includes randome icons
// so tree shaking of icons isn't possible. Can we fix this?
  'flutter build apk --no-tree-shake-icons'.run;
  'flutter install'.run;
}
