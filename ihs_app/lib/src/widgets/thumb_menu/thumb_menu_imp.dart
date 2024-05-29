import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/quick_snack.dart';
import '../expansion_bottom_app_bar/expansion_bottom_app_bar.dart';
import 'menu_item.dart';
import 'menu_item_animator.dart';
import 'menu_item_selected.dart';
import 'thumb_menu.dart';
import 'thumb_menu_overlay.dart';

class ThumbMenuImpl extends StatefulWidget {
  const ThumbMenuImpl(this.context,
      {required this.title,
      required this.menuItems,
      super.key,
      this.expansionMenuKey});
  final String title;

  static const double circleDiameter = ThumbMenu.height * 2;
  // controls how much of the circle peeps above the menu bar.
  // a larger value -ve value shows less circle.
  static const double circleBottom = -0.4 * ThumbMenuImpl.circleDiameter;

  final List<MenuItem> menuItems;

  final GlobalKey<ExpansionBottomAppBarState>? expansionMenuKey;

  final BuildContext context;

  @override
  State<StatefulWidget> createState() => ThumbMenuImplState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(IterableProperty<MenuItem>('menuItems', menuItems))
      ..add(DiagnosticsProperty<GlobalKey<ExpansionBottomAppBarState>?>(
          'expansionMenuKey', expansionMenuKey))
      ..add(DiagnosticsProperty<BuildContext>('context', context));
  }
}

class ThumbMenuImplState extends State<ThumbMenuImpl>
    with TickerProviderStateMixin {
  OverlayEntry? scaffoldEntry;

  MenuItemAnimator? menuItemAnimator;

  @override
  Widget build(BuildContext context) => buildOverlay();

  Widget buildOverlay() {
    menuItemAnimator = MenuItemAnimator(this);

    scaffoldEntry = OverlayEntry(
        builder: (context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<MenuItemAnimator>(
                      create: (_) => menuItemAnimator!),
                  ChangeNotifierProvider<MenuItemSelected>(
                      create: (_) => MenuItemSelected())
                ],
                child: ThumbMenuOverlay(
                    widget.title, widget.menuItems, widget.expansionMenuKey)));

    unawaited(Future<void>.delayed(Duration.zero)
        .then((_) => Overlay.of(context).insert(scaffoldEntry!)));

    // We need to consume the thumb menu's height as the overlay
    // doesn't take any space.
    return Container(
        height: ThumbMenu.height,
        decoration: BoxDecoration(border: Border.all(), color: Colors.black));
  }

  @override
  void dispose() {
    scaffoldEntry?.remove();

    menuItemAnimator?.dispose();
    menuItemAnimator = null;
    super.dispose();
  }

  Future<void> clicked() async {
    await QuickSnack().info(widget.context, 'Clicked');
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(
        DiagnosticsProperty<OverlayEntry?>('scaffoldEntry', scaffoldEntry))
    ..add(DiagnosticsProperty<MenuItemAnimator?>(
        'menuItemAnimator', menuItemAnimator));
  }
}

class ThumbMenuTitle extends StatelessWidget {
  const ThumbMenuTitle({required this.title, required this.opacity, super.key});

  final String title;
  final double opacity;

  @override
  Widget build(BuildContext context) => Opacity(
      opacity: opacity,
      child: Container(
        height: ThumbMenu.height,
        color: Theme.of(context).primaryColor,
        child: Center(
            child: Opacity(
                opacity: 1,
                // display the menu title.
                child: Text(title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        if (opacity != 1)
                          const Shadow(
                            blurRadius: 20,
                            offset: Offset(10, 10),
                          ),
                      ],
                    )))),
      ));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(StringProperty('title', title))
    ..add(DoubleProperty('opacity', opacity));
  }
}
