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
  final RetryData retryData;
  final CompleterEx completer = CompleterEx<RESPONSE_TYPE>();
  final DateTime createdAt;

  Action(this.retryData) : createdAt = DateTime.now();

  /// Return your object encoded as a json string.
  String encodeRequest();
  RESPONSE_TYPE decodeResponse(ActionResponse data);

  Future<RESPONSE_TYPE> get future => completer.future as Future<RESPONSE_TYPE>;

  // mutating actions will be processed before non mutating actions
  bool get causesMutation;

  /// Set of map keys used when sending/receiving action arguments
  // case is important!
  static const ACTION = 'Action';
  static const String MUTATES =
      'MUTATES'; // If true indicates that the action mutates the db.
  static const ENTITY_TYPE = 'EntityType';
  static const ENTITY = 'Entity';
  static const QUERY = 'Query';
  static const PROGRESS_UUID = 'progressUUID';
  static const FIREBASE_TEMP_USER_UID = 'firebaseTempUserUid';
  static const MOBILE_NUMBER = 'mobileNumber';

  /// used to communicate a single boolean response.
  static const BOOL = 'BOOL';
  static const EMAIL_ADDRESS = 'emailAddress';
  static const TIMEZONE = 'timezone';
  static const GUID = 'guid';
  static const ID = 'id';
}

/// [T] the return type for the data returned by the [Action].
abstract class CustomAction<T> extends Action<T> {
  CustomAction(
      {RetryData retryData = const RetryData(RetryOption.NONE, 'oops')})
      : super(retryData);
  Future<T> run();
}
