import 'package:flutter/material.dart';

import '../../util/log.dart';

class MenuItemAnimator extends ChangeNotifier {
  // factory
  MenuItemAnimator(this.ticker)
      : animationController = AnimationController(
            duration: const Duration(milliseconds: duration), vsync: ticker),
        degreesTween = Tween<double>(begin: min, end: max)
            .chain(CurveTween(curve: Curves.easeInOutBack)) {
    itemRotator = degreesTween.animate(animationController);
    itemRotator.addListener(() {
      // notify the menu items to update their rotational position.
      if (itemRotator.value == max) {
        Log.d('Notify called ${itemRotator.value}');
      }
      notifyListeners();
    });

    itemRotator.addStatusListener((state) {
      if (itemRotator.isDismissed) {
        closedCallback?.call();
      }
    });
  }
  static const double min = -30; // so the menu items finish off screen
  static const double max = 180;
  static const int duration = 600;
  bool opening = false;

  VoidCallback? closedCallback;

  TickerProviderStateMixin ticker;

  AnimationController animationController;

  // used to grow the circle when some one clicks on it.
  // we start with a MIN degrees so the menu items start off screen.
  Animatable<double> degreesTween;
  late final Animation<double> itemRotator;

  // static MenuItemAnimator _self ;

  @override
  void dispose() {
    Log.d('disposed');

    animationController.dispose();
    super.dispose();
  }

  void open() {
    opening = true;
    Log.d('Open Menu');
    animationController.forward();
  }

  void close(VoidCallback closedCallback) {
    this.closedCallback = closedCallback;

    Log.d('Close Menu');
    opening = false;
    animationController.reverse();
  }
}
