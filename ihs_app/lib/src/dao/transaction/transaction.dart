import 'dart:async';
import 'dart:convert';

import 'package:completer_ex/completer_ex.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stacktrace_impl/stacktrace_impl.dart';

import '../../app/service_locator.dart';
import '../../util/enum_helper.dart';
import '../../util/log.dart';
import '../../util/ref.dart';
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

  static int actionIdSeed = 1000;

  CompleterEx<void> transactionCompleter = CompleterEx<void>();

  bool sent = false;

  String serviceURL = 'transaction';

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
      final id = actionIdSeed++;
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
        final mostCritical =
            Ref<RetryData>(const RetryData(RetryOption.NONE, null));

        final params = <String, String>{};
        params['apiKey'] = ServiceLocator.getPersistentKeyStore().getApiKey()!;
        params[Action.firebaseTempUserUidKey] =
            ServiceLocator.getPersistentKeyStore()
                .getFirebaseTempUserUid()
                .toString();

        final body = _buildBody(mapRequestIdActionList, mostCritical);

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
    }, mostCritical.obj!)
        // ignore: avoid_types_on_closure_parameters
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
      body += '"$key": ${action.encodeRequest()}';
      for (final action in actions) {
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
      current.obj = next;
    }
    assert(current != null && next != null,
        'current and next cannot both be null');
    final currentOption =
        EnumHelper.getIndexOf(RetryOption.values, current!.obj!.option);
    final nextOption = EnumHelper.getIndexOf(RetryOption.values, next!.option);
    if (currentOption >= nextOption) {
      return;
    }
    current.obj = next;
  }

  Future<void> executeRequest(Map<String, String> params, String body) async {
    await useTransport(TransportOption.standard, serviceURL, params, body)
        .then((responses) {
      try {
        for (final response in responses) {
          final actionList = mapRequestIdActionList[response.actionId];
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
                final s = StackTraceImpl();
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
  ActionFailedException(this.message);
  String message;

  @override
  String toString() => message;
}

enum AuthExceptionType {
  invalidAPIKey,
  userDeleted,
  userDisabled,
  inactiveCustomer
}

class AuthException implements Exception {
  AuthException(String message) {
    final parts = message.split(':');

    if (parts.length == 2) {
      type = EnumHelper.getEnum(parts[0], AuthExceptionType.values);
      this.message = parts[1].trim();
    } else {
      Log.e('Unknown AuthExceptionType');
      type = AuthExceptionType.invalidAPIKey;
      this.message = message;
    }
  }
  late AuthExceptionType type;
  late String message;

  @override
  String toString() => message;
}

Future<List<ActionResponse>> useTransport(TransportOption option,
    String serviceURL, Map<String, String> params, String body) async {
  if (option == TransportOption.isolate) {
    return useIsolateTransport(serviceURL, params, body);
  }
  return useStandardTransport(serviceURL, params, body);
}

Future<List<ActionResponse>> useIsolateTransport(
        String serviceURL, Map<String, String> params, String body) async =>
    TransportIsolate().isolateSend(RequestSenderData(serviceURL, params, body));

Future<List<ActionResponse>> useStandardTransport(
    String serviceURL, Map<String, String> params, String body) async {
  final transport = Transport2(
      ServiceLocator.getPersistentKeyStore().getServerAPIFQDN()!,
      ServiceLocator.serverHttpProtocol,
      basePath: '/micropbx/rest/flutterService2/');

  final rawResponse = await transport.request(serviceURL, params, body);
  final decodedData = decodeActionResponses(rawResponse);
  return decodedData;
}

List<ActionResponse> decodeActionResponses(String data) {
  final responses = json.decode(data) as List<Map>;

  final results = <ActionResponse>[];

  for (final raw in responses) {
    final ret = ActionResponse()
      ..actionId = '${raw['actionId']}'
      ..action = raw['action'] as String
      ..success = raw['success'] as bool
      ..entityType = raw['entityType'] as String
      ..data = raw['data'] as Map<String, dynamic>
      ..singleEntity = raw['singleEntity'] as Map<String, dynamic>
      ..entityList = raw['entityList'] as List<dynamic>
      ..exception = raw['exception'] as String
      ..userExceptionMessage = raw['userExceptionMessage'] as String
      ..exceptionType = raw['exceptionType'] as String;

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

  bool wasSuccessful() => success ?? false;
}

enum TransportOption { standard, isolate }
