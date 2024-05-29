#! /usr/bin/env dart

import 'package:dcli/dcli.dart';

void main(List<String> args) {
  'docker build -t onepub/handyman:latest .'
      .start(workingDirectory: DartProject.self.pathToProjectRoot);
}
