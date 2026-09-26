#! /usr/bin/env dcli

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:dnsolve/dnsolve.dart';
import 'package:ihserver/src/certificate_domains.dart';
import 'package:ihserver/src/config.dart';
import 'package:ihserver/src/credentials.dart';
import 'package:ihserver/src/lockbox_heartbeat.dart';
import 'package:ihserver/src/logger.dart';
import 'package:ihserver/src/mailer.dart';
import 'package:ihserver/src/servers/http.dart';
import 'package:ihserver/src/servers/https.dart';
import 'package:ihserver/src/start_collector.dart';
import 'package:ihserver/src/version/version.g.dart';
import 'package:path/path.dart';

/// Simple web server that can serve static content and email
/// an enquiry.
Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage.');
  late final ArgResults options;
  try {
    options = parser.parse(args);
    if (options.rest.isNotEmpty) {
      throw const FormatException('Unexpected positional arguments.');
    }
  } on FormatException catch (error) {
    stderr
      ..writeln(error.message)
      ..writeln(parser.usage);
    exitCode = 64;
    return;
  }
  if (options['help'] as bool) {
    print('Usage: ihserver\n${parser.usage}');
    return;
  }
  final config = Config();
  qlog('Starting Handyman Server: $packageVersion');
  config.startupReport.forEach(qlog);
  try {
    await config.loadCredentials();
    qlog('Credentials loaded: all three configured variables validated.');
  } on CredentialException catch (error) {
    qlogerr('Credentials unavailable: ${error.failure.name}. ${error.message}');
    qlog('Credentials locked. Open https://${config.fqdn}/unlock to unlock.');
  }
  final pathToStaticContent = config.pathToStaticContent;
  await _checkConfiguration(pathToStaticContent);

  await _checkFQDNResolved(config.fqdn);

  final heartbeat = LockboxHeartbeat(
    url: config.heartbeatUrl,
    isUnlocked: () => config.isUnlocked,
    onFailure: () => qlogerr('Lockbox heartbeat delivery failed.'),
  )..start();
  final domains =
      certificateDomainNames(config.fqdn, additional: config.additionalFqdns)
          .map(
            (name) => CertificateDomain(name: name, email: config.domainEmail),
          )
          .toList();

  if (Config().useHttps) {
    await startHttpsServer(domains);
  } else {
    await startWebServer();
  }

  // The HTTPS unlock page is available while normal routes return 503.
  final retry = Timer.periodic(const Duration(seconds: 10), (_) async {
    if (config.isUnlocked) {
      return;
    }
    try {
      await config.loadCredentials();
    } on CredentialException {
      // A local administrator can also unlock via the Session Agent.
    }
  });
  await config.whenUnlocked;
  retry.cancel();
  await startCollector();
  await heartbeat.send();
  await _sendRestartEmail();
}

Future<void> _checkFQDNResolved(String fqdn) async {
  final dnsolve = DNSolve();
  final response = await dnsolve.lookup(fqdn);
  if (response.answer?.records != null) {
    for (final record in response.answer!.records!) {
      qlog(record.toBind);
    }
  }
}

Future<void> _checkConfiguration(String pathToStaticContent) async {
  final pathToIndexHtml = join(pathToStaticContent, 'index.html');

  if (!exists(pathToIndexHtml)) {
    qlogerr(red('Missing index.html in $pathToIndexHtml'));
    exit(32);
  }
  qlog(blue('Starting web server'));
}

Future<void> _sendRestartEmail() async {
  if (Config().debug) {
    qlog('Debug mode: not sending restart email');
    return;
  }
  qlog('Sending restart email to bsutton@onepub.dev');
  final result = await sendEmail(
    from: 'startup@onepub.dev',
    to: 'bsutton@onepub.dev',
    subject: 'Handy Server Starting',
    body: 'The Handy Server has been restarted',
  );

  if (!result) {
    qlogerr(
      red(
        '''Failed to send startup email: check the configuration at ${Config().loadedFrom}''',
      ),
    );
    exit(33);
  }
}
