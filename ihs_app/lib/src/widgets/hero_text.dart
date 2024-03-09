import 'package:flutter/cupertino.dart';

/// This class is to hack around a know problem when
/// using a hero with text.
///
/// https://github.com/flutter/flutter/issues/12463
///
/// Basically the hero screws up the font styling.
/// This specialised version controls the styling directly
class HeroText extends StatelessWidget {
  final String tag;
  final Widget child;
  // TextStyle from;

  HeroText({this.tag, this.child});
  // , @required BuildContext context})
  // {
  //   // find the first child which is a Text widget.
  //   context.visitChildElements((visitor) {
  //     if (visitor is Text) {
  //       if (from == null) from = (visitor as Text).style;
  //     }
  //   });

  @override
  Widget build(BuildContext context) {
    return Hero(
      flightShuttleBuilder: (_, animation, flightDirection, fromHeroContext, toHeroContext) {
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (_, _child) {
            return DefaultTextStyle.merge(
              child: _child,
              style: TextStyle.lerp(
                  DefaultTextStyle.of(fromHeroContext).style,
                  DefaultTextStyle.of(toHeroContext).style,
                  flightDirection == HeroFlightDirection.pop ? 1 - animation.value : animation.value),
            );
          },
        );
      },
      tag: tag,
      child: child,
    );
  }
}

class HeroNoop extends StatelessWidget {
  final bool noop;
  final Widget child;
  final String tag;
  HeroNoop({this.tag, this.child, this.noop = true});

  @override
  Widget build(BuildContext context) {
    if (noop) {
      return child;
    } else {
      return Hero(tag: tag, child: child);
    }
  }
}

class HeroTextNoop extends StatelessWidget {
  final bool noop;
  final Widget child;
  final String tag;
  HeroTextNoop({this.tag, this.child, this.noop = true});

  @override
  Widget build(BuildContext context) {
    if (noop) {
      return child;
    } else {
      return Hero(tag: tag, child: child); // , context: context);
    }
  }
}
