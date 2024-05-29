import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../util/log.dart';

typedef TickerBuilder = Widget Function(BuildContext context, int index);
typedef OnTick = void Function(int index);

///
/// Acts as a timing source which can either cause a subtree rebuild or
/// generate a tick event.
/// You MUST pass in either a builder or a onTick method.
///
/// The builder is called each interval and is passed the tick count.
/// The onTick is called each interval and is passed the tick count.
///
/// The tick count is incremented each interval until it reaches the
/// limit after which it is reset to zero.
/// The default limit is 100.
/// The build is called each [interval] period.
///
class Ticker extends StatefulWidget {
  const Ticker(
      {required this.onTick,
      required this.child,
      required this.interval,
      super.key,
      this.limit = 100,
      this.active = true});
  final OnTick onTick;
  final Widget child;
  final Duration interval;
  final int limit;
  final bool active;

  @override
  State<StatefulWidget> createState() => TickerState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<OnTick>.has('onTick', onTick))
      ..add(DiagnosticsProperty<Duration>('interval', interval))
      ..add(IntProperty('limit', limit))
      ..add(DiagnosticsProperty<bool>('active', active));
  }
}

class TickerState extends State<Ticker> {
  TickerState() {
    active = widget.active;
  }
  int tickCount = 0;
  late bool active;

  @override
  void initState() {
    super.initState();
    queueTicker();
  }

  @override
  Widget build(BuildContext context) {
    // do we need to restart the ticker?
    // This logic supports the ticker being cycled between active
    // and inactive states.
    // the ticker will only emit events when active and we shutdown the
    // time when inactive to save system resources.
    if (active == false && widget.active == true) {
      // we just got re-activated so restart the time.
      queueTicker();
    }
    active = widget.active;
    return widget.child;
  }

  void queueTicker() {
    Future.delayed(widget.interval, () {
      Log.d(
          '''
onTick called $tickCount active: ${widget.active} mounted: $mounted''');
      if (mounted && active) {
        widget.onTick(tickCount);
        queueTicker();
      }
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('tickCount', tickCount))
      ..add(DiagnosticsProperty<bool>('active', active));
  }
}
