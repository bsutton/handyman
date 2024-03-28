import 'dart:async';

import 'package:flutter/material.dart';

enum BusAction {
  /// Used when the BusBuilder is first instantiated
  /// so that it has an initial state.
  init,
  // a crud insert
  insert,
  // a crud delete
  delete,
  // a crud update
  update,

  // a general notice sent from one part of the app to another.

  notice,
}

///
typedef BusListener<T> = void Function(BusEvent<T> event);
// typedef void BusFilter<T>(BusEvent<T> event);
typedef BusWidgetBuilder<T> = Widget Function(BuildContext context, T entity,
    [T oldEntity]);

class BusEvent<T> {
  BusEvent(this.type, this.action, this.instance, this.oldInstance);
  // The runtype type of the object we are notifying about.
  Type type;
  BusAction action;
  T? instance;
  T? oldInstance;
}

class Bus {
  factory Bus() => _self;

  const Bus._internal();
  static const Bus _self = Bus._internal();
  static final _controller = StreamController<BusEvent<dynamic>>.broadcast();

  void add<T>(BusAction action, {T? instance, T? oldInstance}) {
    _controller.add(BusEvent<T>(T.runtimeType, action, instance, oldInstance));
  }

  Stream<BusEvent<T>> _stream<T>() => _controller.stream
      .where((dynamic event) => event is BusEvent<T>)
      .cast<BusEvent<T>>();

  /// Allows you to listen to Bus events outside of the widget tree.
  /// This is useful for capturing change events from deep within
  /// a nested tree without having to pass a callback down through
  /// multiple layers.
  ///
  /// I would normally recommend that you build a custom class
  /// for passing the data so that you don't get events from
  /// other bits of code.
  ///
  /// Make certain that you dispos of the [StreamSubscription]
  /// once you have finished with the listner.
  ///
  /// ```dart
  /// void initState() {
  ///   super.initState();
  ///    // only listen to events of type <T>
  ///    _subscription = Bus().listen<T>((event) {
  ///      localValue = event;
  ///   });
  ///   _fetchTotal();
  /// }
  /// @override
  /// void dispose() {
  ///   _subscription.cancel();
  ///   super.dispose();
  /// }
  ///
  /// Else where in your code
  ///
  /// Bus().add(BusAction.notice, instance: somedata);
  /// ```
  StreamSubscription<BusEvent<T>> listen<T>(BusListener<T> listener) =>
      _stream<T>().listen((event) => listener(event));
}
