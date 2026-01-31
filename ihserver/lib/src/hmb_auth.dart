import 'package:shelf/shelf.dart';

import 'config.dart';
import 'logger.dart';

bool isHmbAuthorized(Request request) {
  final token = Config().hmbApiToken.trim();
  if (token.isEmpty) {
    qlog('HMB API token not configured.');
    return false;
  }

  final header =
      request.headers['authorization'] ?? request.headers['x-hmb-token'];
  if (header == null) {
    return false;
  }

  var value = header.trim();
  final lower = value.toLowerCase();
  if (lower.startsWith('bearer ')) {
    value = value.substring(7).trim();
  }

  return value == token;
}
