import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../util/log.dart';
import '../expansion_bottom_app_bar/expansion_bottom_app_bar.dart';
import 'menu_item.dart';
import 'thumb_menu_imp.dart';

class ThumbMenu extends StatefulWidget {
  ThumbMenu(
      {required this.title,
      required this.menuItems,
      super.key,
      this.expansionMenuKey}) {
    Log.d('ThumbMenu');
  }
  // const which should be used by widget that display just above the
  // thumb menu.
  // The widget should uses this value as bottom padding to ensure it is clear
  // of the thumb menu's 'Circle' that peeks above the bottom title bar.
  static const double bottomInset = 20;
  static const double height = 50;

  final String title;
  final List<MenuItem> menuItems;
  final GlobalKey<ExpansionBottomAppBarState>? expansionMenuKey;

  @override
  State<StatefulWidget> createState() => ThumbMenuState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(StringProperty('title', title))
    ..add(IterableProperty<MenuItem>('menuItems', menuItems))
    ..add(DiagnosticsProperty<GlobalKey<ExpansionBottomAppBarState>?>(
        'expansionMenuKey', expansionMenuKey));
  }
}

class ThumbMenuState extends State<ThumbMenu> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  // Overlay.of(context).insert(this._overlayEntry);
  //  Scaffold.of
  Widget build(BuildContext context) => ThumbMenuImpl(
        context,
        title: widget.title,
        menuItems: widget.menuItems,
      );
}
