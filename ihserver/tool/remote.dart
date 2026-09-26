import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:settings_yaml/settings_yaml.dart';

import 'scp_command.dart';

/// Resolve relative to the command, so tools also work outside the project.
final projectRoot = path.dirname(path.dirname(Platform.script.toFilePath()));

typedef CommandRunner = Future<void> Function(List<String> arguments);
typedef CaptureCommand = Future<String> Function(List<String> arguments);
typedef ProcessRunner =
    Future<void> Function(String executable, List<String> arguments);

class RemoteDeployment {
  RemoteDeployment({
    required this.server,
    required this.directory,
    required this.project,
    required this.zone,
    required this.bundle,
    CommandRunner run = runGcloud,
    CaptureCommand capture = captureGcloud,
    ProcessRunner runScp = runCommand,
  }) : _run = run,
       _capture = capture,
       _runScp = runScp;

  factory RemoteDeployment.load() {
    final settings = SettingsYaml.load(
      pathToSettings: path.join(projectRoot, 'tool', 'build.yaml'),
    );
    return RemoteDeployment(
      server: settings.asString('target_server'),
      directory: settings.asString('target_directory'),
      project: settings.asString('project'),
      zone: settings.asString('zone'),
      bundle: path.join(projectRoot, 'build', 'install', 'bundle'),
    );
  }

  final String server;
  final String directory;
  final String project;
  final String zone;
  final String bundle;
  final CommandRunner _run;
  final CaptureCommand _capture;
  final ProcessRunner _runScp;

  List<String> get _location => ['--project=$project', '--zone=$zone'];

  Future<void> _ssh(String command) => _run([
    'compute', 'ssh', server, ..._location,
    // Remote sudo may prompt; keep the operator's terminal attached.
    '--ssh-flag=-t', '--command=$command',
  ]);

  Future<void> deploy() async {
    if (directory != '/opt/handyman') {
      throw const FormatException('target_directory must be /opt/handyman.');
    }
    if (!File(path.join(bundle, 'bin', 'install')).existsSync()) {
      throw FileSystemException(
        'No installer build. Run tool/build --local first.',
        bundle,
      );
    }
    final staging =
        '$directory/.install-${DateTime.now().microsecondsSinceEpoch}';
    print('Deploying existing build to $server:$directory');
    await _ssh('mkdir -p -- ${shellQuote(staging)}');
    final generated = await _capture([
      'compute',
      'scp',
      '--dry-run',
      ..._location,
      '--recurse',
      bundle,
      '$server:$staging',
    ]);
    final scp = parseGcloudScp(generated, source: bundle, destination: staging);
    await _runScp(scp.executable, scp.arguments);
    final installer = '$staging/${path.basename(bundle)}/bin/install';
    await _ssh('sudo ${shellQuote(installer)}');
    await _ssh('rm -rf -- ${shellQuote(staging)}');
    print(
      'Deployment to $server complete. Check /var/log/ihserver.log for startup status.',
    );
  }

  Future<void> reload() async {
    await _ssh('sudo ${shellQuote('$directory/bin/ihlaunch')} --reload');
    print(
      'Restart requested on $server. Check /var/log/ihserver.log for startup status.',
    );
  }
}

String shellQuote(String value) => "'${value.replaceAll("'", r"'\''")}'";

Future<void> runGcloud(List<String> arguments) =>
    runCommand('gcloud', arguments);

Future<void> runCommand(String executable, List<String> arguments) async {
  final process = await Process.start(
    executable,
    arguments,
    mode: ProcessStartMode.inheritStdio,
  );
  final code = await process.exitCode;
  if (code != 0) {
    throw ProcessException(
      executable,
      arguments,
      'Remote command failed.',
      code,
    );
  }
}

Future<String> captureGcloud(List<String> arguments) async {
  final result = await Process.run('gcloud', arguments);
  if (result.exitCode != 0) {
    throw ProcessException(
      'gcloud',
      arguments,
      '${result.stderr}',
      result.exitCode,
    );
  }
  return result.stdout as String;
}
