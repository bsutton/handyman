// ignore_for_file: avoid_types_on_closure_parameters

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:shelf/shelf.dart';

import 'config.dart';

Response handleDefault(Request request) => _handleStatic(request, 'index.html');

Response handleStatic(Request request) {
  final filename = request.url.path;
  return _handleStatic(request, filename);
}

Response _handleStatic(Request request, String filename) {
  final pathToContent = pathToStaticContent;
  final pathToFile = truepath(pathToContent, filename);
  if (!pathToFile.startsWith(pathToContent)) {
    return Response.forbidden("The requested path $filename doesn't exist");
  }
  if (!exists(pathToFile)) {
    return Response.notFound("The requested file $filename doesn't exist.");
  }

  final mime = MediaType.parse(
      lookupMimeType('.${extension(filename)}') ?? 'application/octet-stream');

  const oneMonth = '2592000';
  return Response.ok(File(pathToFile).openRead(), headers: {
    'Content-Type': mime.mimeType,
    'Cache-Control': 'max-age=$oneMonth'
  });
}

String? _pathToStaticContent;

String get pathToStaticContent =>
    _pathToStaticContent ??= Config().pathToStaticContent;
