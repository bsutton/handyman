import 'dart:async';
import 'dart:convert';

import 'package:completer_ex/completer_ex.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stacktrace_impl/stacktrace_impl.dart';

import '../../../app/service_locator.dart';
import '../../../util/enum_helper.dart';
import '../../../util/log.dart';
import '../../../util/ref.dart';
import '../repository/actions/action.dart';
import 'api/retry/retry_data.dart';
import 'api/retry/retry_helper.dart';
import 'auto_commit_manager.dart';
import 'isolate.dart';
import 'transport2.dart';

/// Manages calls to the server grouping them into a single database
/// transaction.
/// By default squarephone uses implicit transactions which are highly
/// efficient and you can just ignore transactions.
///
/// Occasionally you may want to implement an explicit transaction.
/// This can be useful if you need to send multiple actions and then
/// await the completion of all of those actions.
///
/// You must use unawaited on each of the db actions to avoid a deadlock
/// (they are awaited but you haven't called commit to send them)
///
/// ```dart
/// var transaction = Transaction(true);
///  unawaited(Repos()
///     .audioFile
///     .insert(audioFile.entity, transaction: transaction));
/// unawaited(Repos()
///     .callForwardTarget
///     .update(widget.callForwardTarget.entity, transaction: transaction));
/// await transaction.commit();
/// ```
///
class Transaction {
  static int actionIdSeed = 1000;

  CompleterEx<void> transactionCompleter = CompleterEx<void>();

  bool sent = false;

  String serviceURL = 'transaction';

  /// If [autoCommit] is true then the transaction
  /// will wait for the next flutter frame or
  /// 200ms before committing the transactions.
  /// This allows multiple actions to be nested in
  /// a single transation.
  Transaction({required bool autoCommit}) {
    if (autoCommit) {
      AutoCommitManager().scheduleCommit(this);
    }
  }

  Map<String, List<Action<dynamic>>> mapRequestIdActionList = {};

  // <R> - the type of the response object that is returned.
  Future<R> addAction<R>(Action<R> action) {
    assert(!sent, 'Action has already been sent');

    var added = false;
    mapRequestIdActionList.forEach((k, actions) {
      if (actions[0] == action) {
        actions.add(action);
        added = true;
        Log.d('Aggregated identical requests $action');
      }
    });

    if (!added) {
      var id = actionIdSeed++;
      mapRequestIdActionList['$id'] = [];
      mapRequestIdActionList['$id']!.add(action);
    }

    return action.future;
  }

  /// Commit the transaction.
  /// The returned Future completes once the commit completes (error or not)
  Future<void> commit() async {
    if (!sent) {
      sent = true;

      try {
        var mostCritical =
            Ref<RetryData>(const RetryData(RetryOption.NONE, null));

        var params = <String, String>{};
        params['apiKey'] = ServiceLocator.getPersistentKeyStore().getApiKey();
        params[Action.FIREBASE_TEMP_USER_UID] =
            ServiceLocator.getPersistentKeyStore()
                .getFirebaseTempUserUid()
                .toString();

        var body = _buildBody(mapRequestIdActionList, mostCritical);

        await _executeSend(params, body, mostCritical, mapRequestIdActionList);
      }
      // ignore: avoid_catches_without_on_clauses
      catch (error, stackTrace) {
        mapRequestIdActionList.forEach((key, value) {
          for (final action in value) {
            if (action.createdAt
                .add(const Duration(seconds: 1))
                .isAfter(DateTime.now())) {
              Log.e('Stale Action being sent: $action');
            }

            Log.w('Notifying action of failure', stackTrace: stackTrace);
            action.completer.completeError(error);
          }
        });
        // If we encounter an error we still need to complete.
        transactionCompleter.completeError(error);
      }
    }
    return transactionCompleter.future;
  }

  Future<void> _executeSend(
      Map<String, String> params,
      String body,
      Ref<RetryData> mostCritical,
      Map<String, List<Action<dynamic>>> actions) async {
    await RetryHelper.exec(() async {
      await executeRequest(params, body);
    }, mostCritical.obj)
        .catchError((Object error) {
      // notify actions of failure
      actions.forEach((key, value) {
        for (final action in value) {
          Log.w('Notifying action of failure');
          action.completer.completeError(error);
        }
      });
    });
  }

  String _buildBody(Map<String, List<Action<dynamic>>> reorderedActions,
      Ref<RetryData> mostCritical) {
    var body = '{';
    reorderedActions.forEach((key, actions) {
      if (body.length > 1) {
        body += ',\n';
      }
      final action = actions[0];
      body += '\"$key\": ${action.encodeRequest()}';
      for (var action in actions) {
        getRetryData(mostCritical, action.retryData);
      }
    });
    body += '}';

    Log.d('sending body $body to $serviceURL');

    return body;
  }

  void getRetryData(Ref<RetryData>? current, RetryData? next) {
    if (current == null && next != null) {
      current!.obj = next;
    }
    if (next == null && current != null) {
      current.obj = next!;
    }
    assert(current != null && next != null,
        'current and next cannot both be null');
    var currentOption =
        EnumHelper.getIndexOf(RetryOption.values, current!.obj.option);
    var nextOption = EnumHelper.getIndexOf(RetryOption.values, next!.option);
    if (currentOption >= nextOption) {
      return;
    }
    current.obj = next;
  }

  Future<void> executeRequest(Map<String, String> params, String body) async {
    await useTransport(TransportOption.STANDARD, serviceURL, params, body)
        .then((responses) {
      try {
        for (var response in responses) {
          var actionList = mapRequestIdActionList[response.actionId];
          assert(actionList != null,
              'failed to map action id ${response.actionId} to an action');
          // Log.d("relaying single result to ${actionList.length} listeners");
          for (final action in actionList!) {
            try {
              if (response.exception == null) {
                final dynamic decoded = action.decodeResponse(response);
                try {
                  action.completer.complete(decoded);
                }
                // ignore: avoid_catches_without_on_clauses
                catch (e, s) {
                  Log.e(e.toString(), stackTrace: s);
                }
              } else {
                var s = StackTraceImpl();
                Log.e(response.exception!, stackTrace: s);
                if (response.exceptionType == 'AuthException') {
                  // The router will ignore this request if the rereg page is
                  // already active.
                  // SQRouter().replaceWithNamed(ReRegistrationPage.routeName);
                  action.completer
                      .completeError(AuthException(response.exception!), s);
                } else {
                  action.completer.completeError(
                      ActionFailedException(response.exception!), s);
                }
              }
            } on UnrecognizedKeysException catch (e, s) {
              Log.e(e.toString(), stackTrace: s);
              Log.e('Allowed Keys: ${e.allowedKeys.join('\n')}');
              Log.e('Unrecognized Keys: ${e.unrecognizedKeys.join('\n')}');
              action.completer.completeError(e, s);
            }
            // ignore: avoid_catches_without_on_clauses
            catch (e, s) {
              Log.e(e.toString(), stackTrace: s);
              action.completer.completeError(e, s);
            }
          }
        }
      } finally {
        /// all actions are complete so mark the transaction as complete.
        transactionCompleter.complete();
      }
    });
  }
}

class ActionFailedException implements Exception {
  String message;
  ActionFailedException(this.message);

  @override
  String toString() => message;
}

enum AuthExceptionType {
  InvalidAPIKey,
  UserDeleted,
  UserDisabled,
  InactiveCustomer
}

class AuthException implements Exception {
  late AuthExceptionType type;
  late String message;

  AuthException(String message) {
    var parts = message.split(':');

    if (parts.length == 2) {
      type = EnumHelper.getEnum(parts[0], AuthExceptionType.values);
      this.message = parts[1].trim();
    } else {
      Log.e('Unknown AuthExceptionType');
      type = AuthExceptionType.InvalidAPIKey;
      this.message = message;
    }
  }

  @override
  String toString() => message;
}

Future<List<ActionResponse>> useTransport(TransportOption option,
    String serviceURL, Map<String, String> params, String body) async {
  if (option == TransportOption.ISOLATE) {
    return await useIsolateTransport(serviceURL, params, body);
  }
  return await useStandardTransport(serviceURL, params, body);
}

Future<List<ActionResponse>> useIsolateTransport(
    String serviceURL, Map<String, String> params, String body) async {
  return await TransportIsolate()
      .isolateSend(RequestSenderData(serviceURL, params, body));
}

Future<List<ActionResponse>> useStandardTransport(
    String serviceURL, Map<String, String> params, String body) async {
  var transport = Transport2(
      ServiceLocator.getPersistentKeyStore().getMpbxApiHost(),
      ServiceLocator.micropbxHttpProtocol,
      basePath: '/micropbx/rest/flutterService2/');

  var rawResponse = await transport.request(serviceURL, params, body);
  var decodedData = decodeActionResponses(rawResponse);
  return decodedData;
}

List<ActionResponse> decodeActionResponses(String data) {
  var responses = json.decode(data) as List<dynamic>;

  var results = <ActionResponse>[];

  for (var raw in responses) {
    var ret = ActionResponse();
    ret.actionId = '${raw['actionId']}';
    ret.action = raw['action'] as String;
    ret.success = raw['success'] as bool;
    ret.entityType = raw['entityType'] as String;
    ret.data = raw['data'] as Map<String, dynamic>;
    ret.singleEntity = raw['singleEntity'] as Map<String, dynamic>;
    ret.entityList = raw['entityList'] as List<dynamic>;
    ret.exception = raw['exception'] as String;
    ret.userExceptionMessage = raw['userExceptionMessage'] as String;
    ret.exceptionType = raw['exceptionType'] as String;

    results.add(ret);
  }

  return results;
}

class ActionResponse {
  String? actionId;
  String? action;
  bool? success;
  String? entityType;
  String? exception;

  /// If the response contains a collection of data
  /// unrelated to any specific entity.
  Map<String, dynamic>? data;

  /// if the response includes a single entity
  Map<String, dynamic>? singleEntity;

  /// if the response includes a list of entities
  List<dynamic>? entityList;
  String? exceptionType;
  String? userExceptionMessage;

  bool wasSuccessful() {
    return success ?? false;
  }
}

enum TransportOption { STANDARD, ISOLATE }
