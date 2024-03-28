import 'package:flutter/material.dart';

import '../app/router.dart';
import '../util/quick_snack.dart';
import '../widgets/thumb_menu/menu_item.dart';
import '../widgets/thumb_menu/thumb_menu.dart';

class TestThumbMenu extends StatefulWidget {
  const TestThumbMenu({super.key});
  static const RouteName routeName = RouteName('/TestThumbMenu');
  static const String title = 'User Dashbaord';

  @override
  TestThumbMenuState createState() => TestThumbMenuState();
}

class TestThumbMenuState extends State<TestThumbMenu> {
  @override
  Widget build(BuildContext context) => Material(
          child: ThumbMenu(title: 'TEST SQUAREPHONE', menuItems: [
        MenuItem('Back', 'Back', onHelp),
        MenuItem('Office', 'Office', onOffce),
        MenuItem('Contact', 'New', onNewContact),
        MenuItem('Help', 'Help', onHelp)
      ]));

  Future<void> onOffce() async {
    await showNotificaction('Office');
  }

  Future<void> onNewContact() async {
    await showNotificaction('Conact');
  }

  Future<void> onHelp() async {
    await showNotificaction('Help');
  }

  Future<void> showNotificaction(String message) async {
    await QuickSnack().info(context, message);
  }
}
