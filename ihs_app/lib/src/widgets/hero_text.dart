import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// This class is to hack around a know problem when
/// using a hero with text.
///
/// https://github.com/flutter/flutter/issues/12463
///
/// Basically the hero screws up the font styling.
/// This specialised version controls the styling directly
class HeroText extends StatelessWidget {
  // TextStyle from;

  const HeroText({required this.tag, required this.child, super.key});
  final String tag;
  final Widget child;
  // , required BuildContext context})
  // {
  //   // find the first child which is a Text widget.
  //   context.visitChildElements((visitor) {
  //     if (visitor is Text) {
  //       if (from == null) from = (visitor as Text).style;
  //     }
  //   });

  @override
  Widget build(BuildContext context) => Hero(
        flightShuttleBuilder:
            (_, animation, flightDirection, fromHeroContext, toHeroContext) =>
                AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (_, _child) => DefaultTextStyle.merge(
            child: _child!,
            style: TextStyle.lerp(
                DefaultTextStyle.of(fromHeroContext).style,
                DefaultTextStyle.of(toHeroContext).style,
                flightDirection == HeroFlightDirection.pop
                    ? 1 - animation.value
                    : animation.value),
          ),
        ),
        tag: tag,
        child: child,
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('tag', tag));
  }
}

class HeroNoop extends StatelessWidget {
  const HeroNoop(
      {required this.tag, required this.child, super.key, this.noop = true});
  final bool noop;
  final Widget child;
  final String tag;

  @override
  Widget build(BuildContext context) {
    if (noop) {
      return child;
    } else {
      return Hero(tag: tag, child: child);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty<bool>('noop', noop))
    ..add(StringProperty('tag', tag));
  }

}

class HeroTextNoop extends StatelessWidget {
  const HeroTextNoop(
      {required this.tag, required this.child, super.key, this.noop = true});
  final bool noop;
  final Widget child;
  final String tag;

  @override
  Widget build(BuildContext context) {
    if (noop) {
      return child;
    } else {
      return Hero(tag: tag, child: child); // , context: context);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty<bool>('noop', noop))
    ..add(StringProperty('tag', tag));
  }

}
