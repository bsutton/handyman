import 'dart:io';

import 'package:path/path.dart' as path;

const installationPath = '/opt/handyman';

/// Only match this installation's binaries or its legacy shell launcher.
bool isServiceProcess(String executable, List<String> arguments) {
  final cleanExecutable = executable.replaceFirst(RegExp(r' \(deleted\)$'), '');
  const bin = '$installationPath/bin';
  return cleanExecutable == '$bin/ihlaunch' ||
      cleanExecutable == '$bin/ihserver' ||
      (['sh', 'bash', 'dash'].contains(path.basename(cleanExecutable)) &&
          arguments.skip(1).contains('$bin/ihlaunch.sh'));
}

/// Stop the supervisor first so it cannot respawn the server during deployment.
Future<List<({int pid, bool server})>> _serviceProcesses() async {
  final processes = <({int pid, bool server})>[];
  await for (final entry in Directory('/proc').list()) {
    final processId = int.tryParse(path.basename(entry.path));
    if (processId == null || processId == pid) {
      continue;
    }
    try {
      final executable = await Link('${entry.path}/exe').target();
      final arguments = (await File(
        '${entry.path}/cmdline',
      ).readAsString()).split('\x00');
      if (isServiceProcess(executable, arguments)) {
        processes.add((
          pid: processId,
          server: executable
              .replaceFirst(' (deleted)', '')
              .endsWith('/ihserver'),
        ));
      }
    } on FileSystemException {
      // Processes may exit while /proc is inspected.
    }
  }
  return processes;
}

Future<void> stopService() async {
  for (final server in [false, true]) {
    // Rescan after stopping the supervisor to catch a last-minute respawn.
    final processes = await _serviceProcesses();
    final targets = processes.where((process) => process.server == server);
    for (final process in targets) {
      Process.killPid(process.pid);
    }
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while (targets.any(
          (process) => Directory('/proc/${process.pid}').existsSync(),
        ) &&
        DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    for (final process in targets) {
      if (Directory('/proc/${process.pid}').existsSync()) {
        Process.killPid(process.pid, ProcessSignal.sigkill);
      }
    }
  }
}

Future<void> startService() async {
  await Process.start(
    '$installationPath/bin/ihlaunch',
    const [],
    workingDirectory: installationPath,
    mode: ProcessStartMode.detached,
  );
}

Future<void> restartService() async {
  await stopService();
  await startService();
}
