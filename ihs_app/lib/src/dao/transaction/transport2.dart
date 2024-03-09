import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:stacktrace_impl/stacktrace_impl.dart';

import '../../../util/log.dart';
import 'api/api_error.dart';
import 'api/http_protocol.dart';

class Transport2 {
  Transport2(String host, HttpProtocol httpProtocol, {required String basePath})
      : _basePath = basePath,
        _httpProtocol = httpProtocol,
        _host = host;
  final String _host;
  final String _basePath;

  final HttpProtocol _httpProtocol;

  static final Client _client = Client();
  // maxOpenConnections: Platform.numberOfProcessors,
  // timeout: const Duration(seconds: 15),
  // // idleTimeout: Duration(seconds: 2),
  // maintainOpenConnections: true);

  Future<String> request(
    String service,
    Map<String, String> params,
    String requestBody,
  ) async {
    final callSite = StackTraceImpl();
    final uri = _uri(service, params);
    Log.d('URI is $uri');
    final headers = <String, String>{};
    headers['content-type'] = 'application/json';

    final res = await _client.post(uri, body: requestBody, headers: headers);

    if (res.statusCode < 200 || res.statusCode > 299) {
      Log.w(res.body, stackTrace: callSite);
      ApiError error;
      if (res.body.isNotEmpty) {
        error = ApiError.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      } else {
        error = ApiError(
            statusCode: res.statusCode,
            date: DateTime.now().toString(),
            generatedBy: 'Rest Client',
            message: 'There was no error message, code is ${res.statusCode}');
      }
      throw error;
    }
    // Added artificial delay for testing
    // Future.delayed(
    //   Duration(milliseconds: 200),
    //   () => completer.complete(body.toString()),
    // );
    return res.body;
  }

  Uri _uri(String service, Map<String, String> params) {
    if (_httpProtocol == HttpProtocol.HTTP) {
      return Uri.http(_host, _basePath + service, params);
    } else if (_httpProtocol == HttpProtocol.HTTPS) {
      return Uri.https(_host, _basePath + service, params);
    } else {
      throw Exception('Invalid Http Protocol');
    }
  }
}
