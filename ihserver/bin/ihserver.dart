#! /usr/bin/env dcli

import 'dart:async';
import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:dnsolve/dnsolve.dart';
import 'package:ihserver/src/config.dart';
import 'package:ihserver/src/logger.dart';
import 'package:ihserver/src/mailer.dart';
import 'package:ihserver/src/servers/http.dart';
import 'package:ihserver/src/servers/https.dart';
import 'package:ihserver/src/start_collector.dart';
import 'package:ihserver/src/version/version.g.dart';
import 'package:path/path.dart';
import 'package:shelf_letsencrypt/shelf_letsencrypt.dart';

/// Simple web server that can serve static content and email
/// an enquiry.
void main() async {
  final config = Config();
  final pathToStaticContent = config.pathToStaticContent;
  await _checkConfiguration(pathToStaticContent);

  await _checkFQDNResolved(config.fqdn);

  final domain = Domain(name: config.fqdn, email: config.domainEmail);

  if (Config().useHttps) {
    await startHttpsServer(domain);
  } else {
    await startWebServer();
  }

  await startCollector();
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
  qlog(green('Starting Handyman Server: $packageVersion'));
  qlog(blue('Loading config.yaml from ${truepath(Config().loadedFrom)}'));
  qlog(blue('Path to static content: $pathToStaticContent'));
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
