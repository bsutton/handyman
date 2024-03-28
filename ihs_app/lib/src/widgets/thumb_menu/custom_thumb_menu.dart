import 'package:flutter/material.dart';
import '../expansion_bottom_app_bar/expansion_bottom_app_bar.dart';

mixin CustomThumbMenu implements Widget {
  final GlobalKey<ExpansionBottomAppBarState> _expansionMenuKey = GlobalKey<ExpansionBottomAppBarState>();

  GlobalKey<ExpansionBottomAppBarState> get expansionMenuKey => _expansionMenuKey;
}
