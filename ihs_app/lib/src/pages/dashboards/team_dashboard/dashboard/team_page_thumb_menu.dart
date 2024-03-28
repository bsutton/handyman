import 'package:flutter/material.dart';
import '../../../../app/router.dart';
import '../../../../widgets/thumb_menu/custom_thumb_menu.dart';
import '../../../../widgets/thumb_menu/menu_item.dart';
import '../../../../widgets/thumb_menu/thumb_menu.dart';

class TeamPageThumbMenu extends StatefulWidget with CustomThumbMenu {
   TeamPageThumbMenu({super.key});

  @override
  State<StatefulWidget> createState() => _TeamPageThumbMenuState();
}

class _TeamPageThumbMenuState extends State<TeamPageThumbMenu> {
  @override
  Widget build(BuildContext context) => ThumbMenu(
        title: 'SQUAREPHONE-TEAMPAGE',
        menuItems: [
          MenuItem('Back', 'Back', onBack),
        ],
        expansionMenuKey: widget.expansionMenuKey);

  void onBack() {
    SQRouter().pop<void>();
  }
}
