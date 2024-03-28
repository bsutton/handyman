import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../util/quick_snack.dart';
import '../../../../widgets/thumb_menu/custom_thumb_menu.dart';
import '../../../../widgets/thumb_menu/menu_item.dart';
import '../../../../widgets/thumb_menu/thumb_menu.dart';
import '../../../contacts/contacts.dart';
import '../../user_dashboard/dashboard/user_dashboard.dart';

class TeamThumbMenu extends StatefulWidget with CustomThumbMenu {
  TeamThumbMenu({super.key});

  @override
  State<StatefulWidget> createState() => _TeamThumbMenuState();
}

class _TeamThumbMenuState extends State<TeamThumbMenu> {
  @override
  Widget build(BuildContext context) => ThumbMenu(
      title: 'SQUAREPHONE',
      menuItems: [
        MenuItem('Office', 'Office', onOffice),
        MenuItem('User', 'User', onUser),
        // MenuItem("Contact", "New", onNewContact),
        MenuItem('Help', 'Help', onHelp)
      ],
      expansionMenuKey: widget.expansionMenuKey);

  Future<void> onOffice() async {
    await SQRouter().pushDefaultRoute();
  }

  Future<void> onUser() async {
    await SQRouter().pushNamed(UserDashboard.routeName);
  }

  Future<void> onNewContact() async {
    await SQRouter().pushNamed(Contacts.routeName);
  }

  Future<void> onHelp() async {
    await QuickSnack().info(context, 'Help');
  }
}
