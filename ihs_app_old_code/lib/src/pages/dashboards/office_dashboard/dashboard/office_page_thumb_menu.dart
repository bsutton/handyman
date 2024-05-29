import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../widgets/thumb_menu/custom_thumb_menu.dart';
import '../../../../widgets/thumb_menu/menu_item.dart';
import '../../../../widgets/thumb_menu/thumb_menu.dart';

class OfficePageThumbMenu extends StatefulWidget with CustomThumbMenu {
  OfficePageThumbMenu({super.key});

  @override
  State<StatefulWidget> createState() => _OfficePageThumbMenuState();
}

class _OfficePageThumbMenuState extends State<OfficePageThumbMenu> {
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
