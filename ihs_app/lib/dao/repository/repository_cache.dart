import '../entities/entity.dart';
import 'actions/action.dart';
import 'cache_ttl.dart';

typedef EntityFieldMatcher<E extends Entity<E>> = Future<bool> Function(
    E entity);

class RepositoryCache<E extends Entity<E>> {
  RepositoryCache(this.cacheDuration);
  static final TTLCache<Action, Entity> _entityActionCache =
      TTLCache<Action, Entity>(
    size: 1000,
  );

  static final TTLCache<Action, List<Entity>> _listActionCache =
      TTLCache<Action, List<Entity>>(size: 100);

  Duration cacheDuration;

  void cacheListAction(Action query, List<E> entities) {
    _listActionCache.set(query, entities);
  }

  void cacheEntityAction(Action query, E entities) {
    _entityActionCache.set(query, entities);
  }

  void clear() {
    _listActionCache.clear();
    _entityActionCache.clear();
  }

  void removeByAction(Action action) {
    _listActionCache.remove(action);
    _entityActionCache.remove(action);
  }

  E getByEntityAction(Action action) =>
      _entityActionCache.get(action, cacheDuration) as E;

  List<E>? getByListAction(Action action) =>
      _listActionCache.get(action, cacheDuration);

  void removeByGUID(GUID guid) {
    // remove for entity cache
    _entityActionCache.copyOfEntrySet().forEach((key, v) {
      if (v.guid == guid) {
        _entityActionCache.remove(key);
      }
    });

    // remove from entity list cache
    _listActionCache.copyOfEntrySet().forEach((key, v) {
      var remove = false;
      for (final ev in v) {
        if (ev.guid == guid) {
          remove = true;
        }
      }
      if (remove) {
        _listActionCache.remove(key);
      }
    });
  }

  void updateByEntity(E entity) {
    // remove for entity cache
    _entityActionCache.copyOfEntrySet().forEach((key, v) {
      if (v.guid == entity.guid) {
        _entityActionCache.set(key, entity);
      }
    });

    // remove from entity list cache
    _listActionCache.copyOfEntrySet().forEach((key, v) {
      var remove = false;
      for (final ev in v) {
        if (ev.guid == entity.guid) {
          remove = true;
        }
      }
      if (remove) {
        _listActionCache.remove(key);
      }
    });
  }

  void invalidateByEntity(E entity) {
    // remove for entity cache
    _entityActionCache.copyOfEntrySet().forEach((key, v) {
      if (v.guid == entity.guid) {
        _entityActionCache.remove(key);
      }
    });

    // remove from entity list cache
    _listActionCache.copyOfEntrySet().forEach((key, v) {
      var remove = false;
      for (final ev in v) {
        if (ev.guid == entity.guid) {
          remove = true;
        }
      }
      if (remove) {
        _listActionCache.remove(key);
      }
    });
  }
}
