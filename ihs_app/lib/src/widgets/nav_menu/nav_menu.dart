import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../pages/contacts/contacts.dart';
import '../../pages/dashboards/user_dashboard/dashboard/user_dashboard.dart';
import '../../pages/test_thumb_menu.dart';
import '../../pages/voicemail/voicemail_index_page.dart';
import '../expansion_bottom_app_bar/expansion_bottom_app_bar.dart';

class NavMenu extends StatefulWidget {
  const NavMenu({required this.currentRoute, super.key});
  final RouteName currentRoute;

  @override
  NavMenuState createState() => NavMenuState();
}

class NavMenuState extends State<NavMenu> {
  bool _doNotDisturb = false;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            dense: true,
            selected: SQRouter().isCurrentRoute(Contacts.routeName),
            leading: const Icon(Icons.contacts),
            title: const Text('Contacts'),
            onTap: () => routeTo(Contacts.routeName)?.call(),
          ),
          ListTile(
            dense: true,
            selected: SQRouter().isCurrentRoute(VoicemailIndexPage.routeName),
            leading: const Icon(Icons.voicemail),
            title: const Text('Voicemail'),
            onTap: () => routeTo(VoicemailIndexPage.routeName),
            /*
            trailing: Chip(
              backgroundColor: Colors.amberAccent,
              label: Text('3'),
            ),
            */
          ),
          ListTile(
            dense: true,
            title: const Text('Do not disturb'),
            subtitle: const Text('Until 6am'),
            leading: Icon(_doNotDisturb
                ? Icons.do_not_disturb_on
                : Icons.do_not_disturb_off),
            onTap: () {},
            trailing: Switch(
              onChanged: (value) {
                setState(() {
                  _doNotDisturb = value;
                });
              },
              value: _doNotDisturb,
            ),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.verified_user),
            title: const Text('User Dashboard'),
            onTap: () => routeTo(UserDashboard.routeName),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.verified_user),
            title: const Text('Test ThumbMenu'),
            onTap: () => routeTo(TestThumbMenu.routeName),
          )
        ],
      );

  GestureTapCallback? routeTo(RouteName routeName) {
    ExpansionBottomAppBar.of(context).close(() async {
      // changed to pushNamed, the old method was reasonable broken anyway and this code isn't in use.
      await SQRouter().pushNamed(routeName);
    });

    return null;
  }
}
