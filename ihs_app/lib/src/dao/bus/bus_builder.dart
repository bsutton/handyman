import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/empty.dart';
import 'bus.dart';

typedef BusFilter<T> = bool Function(BusEvent<T> event);
typedef BusWidgetBuilder<T> = Widget Function(
    BuildContext context, BusEvent<T> event);

class BusBuilder<T> extends StatefulWidget {
  /// The [filter] allows you to filter events.
  /// The [builder] is called when an event is received.
  // / The [initBuilder] is called when the widget needs to
  // /  be built but an event has not yet been recieved.
  // /  If you don't pass an [initBuilder] then an empty
  // /  [Container] will be returned.
  /// [debounce] is not yet implemented.
  const BusBuilder({super.key, this.filter, this.builder, this.debounce});
  final BusFilter<T>? filter;

  final BusWidgetBuilder<T>? builder;
  // final BusWidgetBuilder<T> initBuilder;
  final Duration? debounce;

  @override
  BusBuilderState<T> createState() => BusBuilderState<T>();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<BusFilter<T>?>.has('filter', filter))
      ..add(ObjectFlagProperty<BusWidgetBuilder<T>?>.has('builder', builder))
      ..add(DiagnosticsProperty<Duration?>('debounce', debounce));
  }
}

class BusBuilderState<T> extends State<BusBuilder<T>> {
  BusEvent<T> event =
      BusEvent<T>(T.runtimeType, BusAction.init, null as T, null as T);
  late StreamSubscription<BusEvent<T>> subscription;

  @override
  void initState() {
    super.initState();

    subscription = Bus().listen<T>((event) {
      if (widget.filter != null && widget.filter!(event)) {
        _trigger(event);
      } else {
        _trigger(event);
      }
    });
  }

  void _trigger(BusEvent<T> event) {
    setState(() => this.event = event);
    build(context);
  }

  @override
  void dispose() {
    unawaited(subscription.cancel());

    super.dispose();
  }

  @override
  // if (event.action == BusAction.init)
  // {
  //   return
  // }
  // else
  // {
  Widget build(BuildContext context) =>
      widget.builder?.call(context, event) ?? const Empty();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<BusEvent<T>>('event', event))
      ..add(DiagnosticsProperty<StreamSubscription<BusEvent<T>>>(
          'subscription', subscription));
  }
}
