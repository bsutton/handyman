import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'menu_item.dart';
import 'menu_item_impl.dart';
import 'menu_open_state.dart';

class MenuItems extends StatefulWidget {
  const MenuItems(this.menuItems, this.onNotifyParent, this.closeMenu,
      {super.key});
  final List<MenuItem> menuItems;
  final VoidCallback onNotifyParent;
  final VoidCallback closeMenu;

  @override
  State<StatefulWidget> createState() => MenuItemsState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(IterableProperty<MenuItem>('menuItems', menuItems))
    ..add(
        ObjectFlagProperty<VoidCallback>.has('onNotifyParent', onNotifyParent))
    ..add(ObjectFlagProperty<VoidCallback>.has('closeMenu', closeMenu));
  }
}

class MenuItemsState extends State<MenuItems> {
  // Controls the arc over which menu items are displayed.
  static const int menuItemArc = 170;

  @override
  Widget build(BuildContext context) =>
      buildMenuItems(createMenuItems(widget.menuItems));

  Widget buildMenuItems(List<MenuItemImpl> menuItems) =>
      Consumer<MenuOpenState>(
          builder: (context, menuOpenState, _) =>
              buildOverlay(context, menuOpenState, menuItems));

  List<MenuItemImpl> createMenuItems(List<MenuItem> menuItems) {
    final axleCount = menuItems.length;
    final gapCount = axleCount + 1;
    const arcOffset = (180 - menuItemArc) ~/ 2;

    // the no. of degrees for the gap between each menu item.
    final gapArc = menuItemArc / gapCount;
    var index = 0;
    final menuItemImpls = <MenuItemImpl>[];
    for (final menuItem in menuItems) {
      menuItemImpls.add(buildMenuItem(menuItem, arcOffset, gapArc, index));
      index++;
    }

    return menuItemImpls;
  }

  MenuItemImpl buildMenuItem(
      MenuItem menuItem, int arcOffset, double gapArc, int index) {
    final rotation = arcOffset + gapArc + (index * gapArc);

    // Log.d("MenuItem: ${menuItem.label} $rotation");
    return MenuItemImpl(
        onNotifyParent: widget.onNotifyParent,
        onTap: menuItem.onSelected,
        label: menuItem.label,
        svgFilename: menuItem.svgFilename,
        degrees: rotation);
  }

  Widget buildOverlay(BuildContext context, MenuOpenState menuOpenState,
      List<MenuItemImpl> menuItems) {
    if (menuOpenState.isOpen) {
      // OverlayState overlayState = Overlay.of(context);
      return Stack(clipBehavior: Clip.antiAlias, children: menuItems);
    } else {
      return Container();
    }
  }
}
