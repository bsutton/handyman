import 'package:flutter/material.dart';
import '../../app/router.dart';
import '../../pages/contacts/contacts.dart';
import '../../pages/dashboards/user_dashboard/dashboard/user_dashboard.dart';
import '../../pages/test_thumb_menu.dart';
import '../../pages/voicemail/voicemail_index_page.dart';
import '../expansion_bottom_app_bar/expansion_bottom_app_bar.dart';

class NavMenu extends StatefulWidget {
  final RouteName currentRoute;
  NavMenu({Key key, @required this.currentRoute})
      : assert(currentRoute != null),
        super(key: key);

  @override
  _NavMenuState createState() => _NavMenuState();
}

class _NavMenuState extends State<NavMenu> {
  bool _doNotDisturb = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          dense: true,
          selected: SQRouter().isCurrentRoute(Contacts.routeName),
          leading: Icon(Icons.contacts),
          title: Text('Contacts'),
          onTap: () => routeTo(Contacts.routeName)(),
        ),
        ListTile(
          dense: true,
          selected: SQRouter().isCurrentRoute(VoicemailIndexPage.routeName),
          leading: Icon(Icons.voicemail),
          title: Text('Voicemail'),
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
          title: Text('Do not disturb'),
          subtitle: Text('Until 6am'),
          leading: Icon(_doNotDisturb ? Icons.do_not_disturb_on : Icons.do_not_disturb_off),
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
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {},
        ),
        ListTile(
          dense: true,
          leading: Icon(Icons.verified_user),
          title: Text('User Dashboard'),
          onTap: () => routeTo(UserDashboard.routeName),
        ),
        ListTile(
          dense: true,
          leading: Icon(Icons.verified_user),
          title: Text('Test ThumbMenu'),
          onTap: () => routeTo(TestThumbMenu.routeName),
        )
      ],
    );
  }

  GestureTapCallback routeTo(RouteName routeName) {
    ExpansionBottomAppBar.of(context)?.close(() {
      // changed to pushNamed, the old method was reasonable broken anyway and this code isn't in use.
      SQRouter().pushNamed(routeName);
    });

    return null;
  }
}
