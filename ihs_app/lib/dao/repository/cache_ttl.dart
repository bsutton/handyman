import 'package:dcache/dcache.dart';

class TTLCache<K, V> {
  SimpleStorage<K, V> _storage;
  Cache<K, V> _cache;

  OnEvict<K, V> onEvict;
  TTLCache({int size, this.onEvict}) {
    _storage = SimpleStorage(size: size);
    _cache = LruCache<K, V>(storage: _storage, onEvict: onEvict);
  }

  void clear() {}

  V get(K key, Duration ttl) {
    var entry = _storage.get(key);
    if (entry != null) {
      var cutoff = DateTime.now().subtract(ttl);

      if (entry.insertTime.isBefore(cutoff)) {
        if (onEvict != null) {
          onEvict(key, entry.value);
        }
        return null;
      }
    }
    return _cache.get(key);
  }

  void set(K key, V value) {
    _cache.set(key, value);
  }

  void operator []=(K key, V value) {
    _cache[key] = value;
  }

  void remove(K key) {
    _storage.remove(key);
  }

  Map<K, V> copyOfEntrySet() {
    var entrySet = <K, V>{};
    for (var key in _storage.keys) {
      entrySet[key] = _storage.get(key).value;
    }
    return entrySet;
  }
}
