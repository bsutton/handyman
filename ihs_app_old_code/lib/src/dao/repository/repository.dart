import 'dart:async';

import 'package:completer_ex/completer_ex.dart';

import '../entities/entity.dart';
import '../entities/entity_settings.dart';
import '../transaction/api/retry/retry_data.dart';
import '../transaction/query.dart';
import '../transaction/transaction.dart';
import '../transaction/transaction_factory.dart';
import '../types/er.dart';
import 'actions/action.dart';
import 'actions/action_count.dart';
import 'actions/action_delete.dart';
import 'actions/action_get_by_guid.dart';
import 'actions/action_get_by_id.dart';
import 'actions/action_insert.dart';
import 'actions/action_query.dart';
import 'actions/action_update.dart';
import 'repository_cache.dart';

abstract class Repository<E extends Entity<E>> extends EntitySettings<E> {
  Repository(Duration cacheDuration) : _cache = RepositoryCache(cacheDuration);
  final RepositoryCache<E> _cache;

  Future<List<E>> getAll({
    bool force = false,
    RetryData retryData = RetryData.defaultRetry,
    int offset = 0,
    int limit = 100,
  }) {
    final query = Query(entity, offset: offset, limit: limit);
    return select(query, force: force, retryData: retryData);
  }

  Future<List<E>> getList(String fieldName, String value,
      {bool force = false, RetryData retryData = RetryData.defaultRetry}) {
    final filters = <Match>[Match(fieldName, value)];
    final query = Query(entity, filters: filters);
    return select(query, force: force, retryData: retryData);
  }

  Future<E?> getFirst(String fieldName, String value,
      {Transaction? transaction,
      bool force = false,
      RetryData retryData = RetryData.defaultRetry}) async {
    final filters = <Match>[Match(fieldName, value)];
    final query = Query(entity, limit: 1, filters: filters);

    final completer = CompleterEx<E>();

    try {
      final list = await select(query,
          force: force, retryData: retryData, transaction: transaction);
      if (list.isNotEmpty) {
        completer.complete(list[0]);
      } else {
        completer.complete(null);
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<List<E>> select(Query query,
      {Transaction? transaction,
      bool force = false,
      RetryData retryData = RetryData.defaultRetry}) {
    final action = ActionQuery<E>(query, this, retryData);
    return getByListAction(action, force: force, transaction: transaction);
  }

  Future<int> count(Query query,
      {Transaction? transaction,
      bool force = false,
      RetryData retryData = RetryData.defaultRetry}) {
    final action = ActionCount<E>(query, this, retryData);

    findTransaction(transaction).addAction(action);

    //TODO: consider caching this action's results

    return action.future;
  }

  Future<int> countAll({
    required Transaction transaction,
    bool force = false,
    RetryData retryData = RetryData.defaultRetry,
  }) {
    final query = Query(entity);
    return count(
        transaction: transaction, query, force: force, retryData: retryData);
  }

  Future<List<E>> getByListAction(Action<List<E>> action,
      {Transaction? transaction,
      bool force = false,
      RetryData retryData = RetryData.defaultRetry}) {
    if (force == false) {
      final cachedResults = _cache.getByListAction(action);
      return Future.value(cachedResults);
    }
    findTransaction(transaction).addAction(action);
    action.future.then((list) {
      _cache.cacheListAction(action, list);
    });
    return action.future;
  }

  static Transaction findTransaction(Transaction? transaction) {
    if (transaction == null) {
      return TransactionFactory.getActiveTransaction();
    }
    return transaction;
  }

  Future<E> getById(int id,
          {required Transaction transaction,
          RetryData retryData = RetryData.defaultRetry}) =>
      addGetAction(ActionGetById<E>(id, this, retryData), transaction);

  Future<E> addGetAction(Action<E> action, Transaction? transaction) {
    final value = _cache.getByEntityAction(action);
    return Future.value(value);
  }

  /// Retrives an entity [E] by its guid.
  /// The Future will return null if the entity doesn't exist.
  Future<E> getByGUID(GUID guid,
          {Transaction? transaction,
          RetryData retryData = RetryData.defaultRetry}) async =>
      addGetAction(ActionGetByGuid<E>(guid, this, retryData), transaction);

  Future<ER<E>> insert(E entity,
      {Transaction? transaction,
      RetryData retryData = RetryData.defaultRetry}) {
    final action = ActionInsert<E>(entity, this, retryData);
    findTransaction(transaction).addAction(action);
    action.future.then((er) {
      _cache.invalidateByEntity(er.entity);
    });
    return action.future;
  }

  /// Updates the server db and then the local cache
  /// with a full copy of the new entity.
  Future<ER<E>> update(E entity,
      {Transaction? transaction,
      RetryData retryData = RetryData.defaultRetry}) {
    final action = ActionUpdate<E>(entity, this, retryData);
    findTransaction(transaction).addAction(action);
    action.future.then((er) {
      _cache.updateByEntity(er.entity);
    });
    return action.future;
  }

  Future<bool> delete(E entity,
      {Transaction? transaction,
      RetryData retryData = RetryData.defaultRetry}) {
    final action = ActionDelete<E>(entity, this, retryData);
    findTransaction(transaction).addAction(action);
    action.future.then((er) {
      flushCache(entity.guid!);
    });
    return action.future;
  }

  /// removes any entities in the cache with the give guid
  void flushCache(GUID guid) {
    _cache.removeByGUID(guid);
  }
}
