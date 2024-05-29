import 'package:flutter/material.dart';

import 'menu_item_impl.dart';

class MenuItemSelected extends ChangeNotifier {
  MenuItemImplState? _selected;

  bool isSelected(MenuItemImplState menuItem) => menuItem == _selected;

  void select(MenuItemImplState selected) {
    _selected = selected;
    notifyListeners();
  }
}
