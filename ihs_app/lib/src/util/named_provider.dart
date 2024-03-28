import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stacktrace_impl/stacktrace_impl.dart';

import 'log.dart';

///
/// Based on the concept of Providers a [NamedProvider] allows you to
/// get access to the provided data even if you are not in the widget
/// tree and without needing a [BuildContext].
///
/// An NamedProvider is useful if your widget needs to launch Dialogs
/// or open new pages. Dialogs and Pages are anchoured to the root
/// of the widget tree and as such can't see a normal Provider.
/// A [NamedProvider] is always visible, provided that it remains
/// in the wiget tree which is normally the case if you load a Dialog
/// or a Page.
///
/// See: [NamedProviderFactory]
///      [NamedConsumer]
///
///
class NamedProvider<T extends ChangeNotifier> extends StatefulWidget {
  /// The [child] will be rendered in under the NamedProvider.
  /// The [create] method is called to generate the state object
  /// which is made available by the provider.
  const NamedProvider({
    required this.create,
    required this.child,
    super.key,
  });
  final T Function() create;
  final Widget child;

  static T? of<T extends ChangeNotifier>() => NamedProviderFactory().of<T>();

  @override
  NamedProviderState createState() => NamedProviderState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<T Function()>.has('create', create));
  }
}

class NamedProviderState<T extends ChangeNotifier>
    extends State<NamedProvider> {
  NamedProviderState() {
    state = widget.create() as T;
  }

  late T state;

  @override
  void initState() {
    super.initState();

    NamedProviderFactory()._register(state);
  }

  @override
  void dispose() {
    Log.d('disposing of NamedProvider ${state.runtimeType}');
    NamedProviderFactory()._deregister(state);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('state', state));
  }
}

///
/// The [NamedProviderFactory] provides 'global' access to any
/// state exposed via a NamedProvider.
///
/// You can use the [NamedProviderFactory.of] method to
/// obtain the state object provided the [NamedProvider] is in the
/// widget tree.
class NamedProviderFactory {
  factory NamedProviderFactory() {
    _self ??= NamedProviderFactory._internal();
    return _self!;
  }

  NamedProviderFactory._internal();
  static NamedProviderFactory? _self;

  // The set of registered subscribers
  static Map<StateKey<dynamic>, StateSubscriber> registered = {};

  /// Returns the state object identified by the given
  /// type.
  ///
  /// ```dart
  /// NamedProviderFactory().of<MyState>();
  /// ```
  ///
  /// If the named state object doesn't exist a [NamedProviderException] will
  /// be thrown unless the parameter [throwOnNotFound] is set to false.
  ///
  T? of<T extends ChangeNotifier>({bool throwOnNotFound = true}) {
    final sub = registered[StateKey<T>(T)];
    if (sub == null) {
      final message = 'The Named State $T was not found.';

      if (throwOnNotFound) {
        throw NamedProviderException(message);
      }
    }
    return sub == null ? null : sub.state as T;
  }

  /// Used by NamedProvider to stores the [state].
  /// The state.runtimeType MUST be unique.
  /// This
  void _register<T extends ChangeNotifier>(T state,
      {bool throwOnExisting = true}) {
    Log.d('Registering state: ${state.runtimeType}');
    final stateKey = StateKey<T>(state.runtimeType);
    if (!registered.containsKey(stateKey)) {
      registered[stateKey] = StateSubscriber<T>(state);
    } else if (throwOnExisting) {
      final message = 'The Named State  $state.runtimeType already exists.';
      Log.d(message);
      final sub = registered[stateKey];
      throw NamedProviderException('$message ${sub?.st.formatStackTrace()}');
    }
  }

  /// Used by [NamedProvider] to clean registered state objects
  /// that are no longer required.
  void _deregister<T extends ChangeNotifier>(T state) {
    Log.d('Registering state: ${state.runtimeType}');
    final stateKey = StateKey<T>(state.runtimeType);
    if (registered.containsKey(stateKey)) {
      registered.remove(stateKey);
    } else {
      final message = 'The Named State $state.runtimeType does not exist.';
      Log.e(message);
      throw NamedProviderException(message);
    }
  }
}

class NamedProviderException implements Exception {
  NamedProviderException(this.message);
  String message;
}

///////////////////////////////////////////////////////////////////////
///
/// NamedConsumer
///
///////////////////////////////////////////////////////////////////////

///
/// Use a consume to listen to changes to a state object registered via
/// [NamedProvider]. When the state calls notifyListeners the
/// [NamedConsumer] will be rebuilt.
///
class NamedConsumer<T extends ChangeNotifier> extends StatefulWidget {
  /// Listen to updates from a named object.
  /// [builder] the builder which is called whenever the tree needs
  /// to be built.
  /// [child] is passed to the builder and allows you to optimise
  /// a child widget tree that doesn't changed just because this
  /// consumer is being rebuilt.
  ///
  /// ```dart
  /// NamedConsumer<TestState>(
  ///   builder: (context, mystate, child) {
  ///     return Row[Text(mystate.myname), child];
  ///   }
  /// )
  /// ```
  const NamedConsumer({required this.builder, super.key, this.child});
  final Widget Function(BuildContext context, T state, Widget child) builder;
  final Widget? child;

  @override
  NamedConsumerState createState() => NamedConsumerState<T>();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<
            Widget Function(BuildContext context, T state, Widget child)>.has(
        'builder', builder));
  }
}

class NamedConsumerState<T extends ChangeNotifier>
    extends State<NamedConsumer<T>> {
  NamedConsumerState() {
    state = NamedProviderFactory().of<T>();
    state!.addListener(updated);
  }
  late T? state;

  void updated() {
    setState(() {});
  }

  @override
  void dispose() {
    state!.removeListener(() => updated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, state!, widget.child!);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T?>('state', state));
  }
}

class StateKey<T> extends Equatable {
  const StateKey(this.runtimeType);
  @override
  final Type runtimeType;

  @override
  List<Object> get props => [runtimeType];
}

class StateSubscriber<T extends ChangeNotifier> {
  StateSubscriber(this.state)
      : runtimeType = state.runtimeType,
        st = StackTraceImpl();
  @override
  final Type runtimeType;
  final T state;
  final StackTraceImpl st;

  void addListener(VoidCallback subcriber) => state.addListener(subcriber);
  void removeListener(VoidCallback subcriber) =>
      state.removeListener(subcriber);
}
