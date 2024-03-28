import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../widgets/thumb_menu/custom_thumb_menu.dart';
import '../../../../widgets/thumb_menu/menu_item.dart';
import '../../../../widgets/thumb_menu/thumb_menu.dart';

class UserPageThumbMenu extends StatefulWidget with CustomThumbMenu {
  UserPageThumbMenu({super.key});

  @override
  State<StatefulWidget> createState() => _UserPageThumbMenuState();
}

class _UserPageThumbMenuState extends State<UserPageThumbMenu> {
  @override
  Widget build(BuildContext context) => ThumbMenu(
      title: 'SQUAREPHONE-USERPAGE',
      menuItems: [
        MenuItem('Back', 'Back', onBack),
      ],
      expansionMenuKey: widget.expansionMenuKey);

  void onBack() {
    SQRouter().pop<void>();
  }
}
