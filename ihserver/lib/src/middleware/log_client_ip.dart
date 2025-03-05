import 'dart:io';

import 'package:shelf/shelf.dart';

import '../logger.dart';

/// Custom middleware to log the date/time, client IP, method, URL, and response status.
Middleware logClientRequestMiddleware() =>
    (innerHandler) => (request) async {
      final start = DateTime.now();
      final clientIp = getClientIp(request);
      // Process the request.
      final response = await innerHandler(request);
      // Log date/time, client IP, method, URL, and response status.
      qlog(
        '''
${start.toIso8601String()} | $clientIp | ${request.method} ${request.requestedUri} | ${response.statusCode}''',
      );
      return response;
    };

/// We are behind a cloudflare proxy so the client's actual IP address
/// is in a header

String getClientIp(Request request) {
  // Check Cloudflare header first.
  final cfConnectingIp = request.headers['CF-Connecting-IP'];
  if (cfConnectingIp != null && cfConnectingIp.isNotEmpty) {
    return cfConnectingIp;
  }
  // Fallback: check X-Forwarded-For header.
  final xForwardedFor = request.headers['x-forwarded-for'];
  if (xForwardedFor != null && xForwardedFor.isNotEmpty) {
    // In X-Forwarded-For, the first IP is usually the client IP.
    return xForwardedFor.split(',').first.trim();
  }
  // Fallback to shelf's connection info.
  final connectionInfo = request.context['shelf.io.connection_info'];
  if (connectionInfo is HttpConnectionInfo) {
    return connectionInfo.remoteAddress.address;
  }
  return 'unknown';
}
