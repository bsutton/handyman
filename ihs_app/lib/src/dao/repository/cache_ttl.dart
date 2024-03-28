import 'package:dcache/dcache.dart';

class TTLCache<K, V> {
  TTLCache({required int size, this.onEvict})
      : _storage = InMemoryStorage(size) {
    _cache = LruCache<K, V>(storage: _storage, onEvict: onEvict);
  }
  final InMemoryStorage<K, V> _storage;
  late Cache<K, V> _cache;

  OnEvict<K, V>? onEvict;

  void clear() {}

  V? get(K key, Duration ttl) {
    final entry = _storage.get(key);
    if (entry != null) {
      final cutoff = DateTime.now().subtract(ttl);

      if (entry.insertTime.isBefore(cutoff)) {
        onEvict?.call(key, entry.value);
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
    final entrySet = <K, V>{};
    for (final key in _storage.keys) {
      entrySet[key] = _storage.get(key)!.value as V;
    }
    return entrySet;
  }
}
