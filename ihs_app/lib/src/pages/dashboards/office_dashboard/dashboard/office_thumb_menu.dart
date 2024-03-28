import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../util/quick_snack.dart';
import '../../../../widgets/thumb_menu/custom_thumb_menu.dart';
import '../../../../widgets/thumb_menu/menu_item.dart';
import '../../../../widgets/thumb_menu/thumb_menu.dart';
import '../../../contacts/contacts.dart';

class OfficeThumbMenu extends StatefulWidget with CustomThumbMenu {
  OfficeThumbMenu({super.key});

  @override
  State<StatefulWidget> createState() => _OfficeThumbMenuState();
}

class _OfficeThumbMenuState extends State<OfficeThumbMenu> {
  @override
  Widget build(BuildContext context) => ThumbMenu(
      title: 'SQUAREPHONE',
      menuItems: [
        MenuItem('Office', 'Office', onOffce),
        // MenuItem("Contact", "New", onNewContact),
        MenuItem('Help', 'Help', onHelp)
      ],
      expansionMenuKey: widget.expansionMenuKey);

  Future<void> onOffce() async {
    await SQRouter().pushDefaultRoute();
  }

  Future<void> onNewContact() async {
    await SQRouter().pushNamed(Contacts.routeName);
  }

  Future<void> onHelp() async {
    await QuickSnack().info(context, 'Help');
  }
}
