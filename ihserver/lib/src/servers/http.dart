import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import '../config.dart';
import '../logger.dart';
import '../middleware/log_client_ip.dart';
import '../router.dart';
import 'rate_limiter.dart';

late HttpServer server;

Future<void> startWebServer() async {
  final router = buildRouter();

  final handler = const Pipeline()
      .addMiddleware(logClientRequestMiddleware())
      .addMiddleware(rateLimiter.rateLimiter())
      .addHandler(router.call);

  final server = await serve(
    handler,
    Config().bindingAddress,
    Config().httpPort,
  );
  qlog('Serving at http://${server.address.host}:${server.port}');
}
