import 'dart:async';

import 'package:completer_ex/completer_ex.dart';

class Ref<T> {
  Ref(this.obj);
  Ref.empty();
  T? obj;

  bool get isNotEmpty => obj != null;
  bool get isEmpty => obj == null;

  static bool isNotNullOrEmpty<T>(Ref<T> ref) => ref.obj != null;
}

/// A reference to an object of type [T]
/// which will be resolved at a later date.
/// You can resolve the object by either:
/// [Ref.obj] = value
/// or
/// [FutureRef.withResolver] = () => willResolve();
class FutureRef<T> {
  FutureRef();

  /// Ctor that takes a method which is able to resolve
  /// the wrapped object.
  /// Once the [resolver] completes [future] will
  /// return the resolved entity.
  FutureRef.withResolver(Future<T> Function() resolver) {
    unawaited(resolver().then((resolved) => obj = resolved));
  }
  CompleterEx<Ref<T>> completer = CompleterEx();

  final Ref<T> _wrapped = Ref<T>.empty();

  Future<Ref<T>> get future => completer.future;

  bool get isCompleted => completer.isCompleted;

  T get obj {
    assert(isCompleted, 'The Reference has been resolved.');
    return _wrapped.obj!;
  }

  /// When you call this method the object
  /// is marked as completed and the [future]
  /// will return the resolved entity.
  set obj(T obj) {
    _wrapped.obj = obj;
    if (!completer.isCompleted) {
      completer.complete(_wrapped);
    }
  }

  bool get isNotEmpty => obj != null;
  bool get isEmpty => obj == null;
}
