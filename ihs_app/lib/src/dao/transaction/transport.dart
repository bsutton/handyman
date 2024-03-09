import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:completer_ex/completer_ex.dart';
import 'package:stacktrace_impl/stacktrace_impl.dart';

import '../../../util/log.dart';
import 'api/api_error.dart';
import 'api/http_protocol.dart';

class Transport {
  Transport(String host, HttpProtocol httpProtocol, {required String basePath})
      : _basePath = basePath,
        _httpProtocol = httpProtocol,
        _host = host;
  final String _host;
  final String _basePath;

  final HttpProtocol _httpProtocol;

  static final HttpClient _client = HttpClient();

  final ContentType _contentType = ContentType('application', 'json');

  Future<String> request(
    String service,
    Map<String, String> params,
    String requestBody,
  ) async {
    final callSite = StackTraceImpl();
    final completer = CompleterEx<String>();
    _client.connectionTimeout = const Duration(seconds: 15);
    try {
      final uri = _uri(service, params);
      Log.d('URI is $uri');
      await _client.postUrl(uri).then((req) {
        // Write request
        req.headers.contentType = _contentType;
        req.write(requestBody);
        return req.close();
      }).then((res) {
        // Handle response
        final responseBody = StringBuffer();
        res.transform(utf8.decoder).listen(
              responseBody.write,
              onDone: () => _onDone(res, responseBody, callSite, completer),
              // ignore: avoid_types_on_closure_parameters
              onError: (dynamic e, StackTrace s) =>
                  _onError(e, s, callSite, completer),
              cancelOnError: true,
            );
      }).catchError(
          // ignore: avoid_types_on_closure_parameters
          (dynamic e, StackTrace s) => _onError(e, s, callSite, completer));
    }
    // ignore: avoid_catches_without_on_clauses
    catch (e, s) {
      // catch socket timeout here
      completer.completeError(e, s);
    }
    return completer.future;
  }

  void _onError(dynamic e, StackTrace s, StackTraceImpl callSite,
      CompleterEx<String> completer) {
    completer.completeError(e as Object, s);
  }

  void _onDone(HttpClientResponse res, StringBuffer responseBody,
      StackTraceImpl callSite, CompleterEx<String> completer) {
    if (res.statusCode < 200 || res.statusCode > 299) {
      Log.w(responseBody.toString(), stackTrace: callSite);
      var error = ApiError(
          date: DateTime.now().toString(),
          generatedBy: 'Rest Client',
          message: 'There was no error message, code is ${res.statusCode}');
      if (responseBody.toString().isNotEmpty) {
        error = ApiError.fromJson(
            jsonDecode(responseBody.toString()) as Map<String, dynamic>);
      }
      completer.completeError(error);
      return;
    }
    // Added artificial delay for testing
    // Future.delayed(
    //   Duration(milliseconds: 200),
    //   () => completer.complete(body.toString()),
    // );
    completer.complete(responseBody.toString());
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
