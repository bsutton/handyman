import 'package:flutter/material.dart';

import 'thumb_menu.dart';

class MenuOpenState extends ChangeNotifier {
  // static MenuOpenState _self = MenuOpenState._internal() ;

  // factory
  MenuOpenState() {
    //return _self;
  }
  bool _isOpen = false;
  double height = ThumbMenu.height;

  // MenuOpenState._internal();

  void open() {
    _isOpen = true;

    height = ThumbMenu.height * 6;

    notifyListeners();
  }

  void close() {
    _isOpen = false;
    notifyListeners();
  }

  bool get isOpen => _isOpen;
}
