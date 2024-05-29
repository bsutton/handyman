import 'dart:async';

import 'package:completer_ex/completer_ex.dart';
import 'package:equatable/equatable.dart';

import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';

/// [Action]s are used to cross the network boundary
/// between flutter and the java backend.
///
/// An [Action] essentially encapsulates the details
/// of an action that is to be performed by the backend.
///
/// Actions can cause a mutation of data on the server
/// (CRUD operations) or simply fetch data (sql select).
///
/// [Action]s are sent across the network boundary
/// wrapped in a [Transaction].
///
/// When the transaction is executed on the server it may
/// re-order events to optimise them.
///
/// Any Action which is a mutating event will be executed
/// before any non-mutating event.
///
/// e.g. CRUD actions are executed before a Select action.
///
/// The re-ordering ensures that any select statements
/// reflect any mutations that have occured in the same
/// transaction.
///
///
///
/// [RESPONSE_TYPE] - the type of data being returned from the Action
///     this may be an Entity a List<Entity> or any other data
///  that the action chooses to return.
abstract class Action<RESPONSE_TYPE> extends Equatable {
  Action(this.retryData) : createdAt = DateTime.now();
  final RetryData retryData;
  final completer = CompleterEx<RESPONSE_TYPE>();
  final DateTime createdAt;

  /// Return your object encoded as a json string.
  String encodeRequest();
  RESPONSE_TYPE decodeResponse(ActionResponse data);

  Future<RESPONSE_TYPE> get future => completer.future;

  // mutating actions will be processed before non mutating actions
  bool get causesMutation;

  /// Set of map keys used when sending/receiving action arguments
  // case is important!
  static const action = 'Action';
  static const String mutatesKey =
      'MUTATES'; // If true indicates that the action mutates the db.
  static const entityTypeKey = 'EntityType';
  static const entityKey = 'Entity';
  static const queryKey = 'Query';
  static const processUuidKey = 'progressUUID';
  static const firebaseTempUserUidKey = 'firebaseTempUserUid';
  static const mobileNumberKey = 'mobileNumber';

  /// used to communicate a single boolean response.
  static const boolKey = 'BOOL';
  static const emailAdderssKey = 'emailAddress';
  static const timezoneKey = 'timezone';
  static const guidKey = 'guid';
  static const idKey = 'id';
}

/// [T] the return type for the data returned by the [Action].
abstract class CustomAction<T> extends Action<T> {
  CustomAction(
      {RetryData retryData = const RetryData(RetryOption.NONE, 'oops')})
      : super(retryData);
  Future<T> run();
}
