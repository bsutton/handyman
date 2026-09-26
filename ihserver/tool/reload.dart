#! /usr/bin/env dart

import 'deploy.dart' as deploy;

Future<void> main(List<String> args) => deploy.main(['--reload', ...args]);
