import 'package:flutter/material.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../widgets/theme/nj_text_themes.dart';
import '../../dashboard_page.dart';
import '../dashboard/user_page_thumb_menu.dart';

class ConferencePage extends StatefulWidget {
  const ConferencePage({super.key});
  static const RouteName routeName = RouteName('/conferencepage');

  @override
  ConferencePageState createState() => ConferencePageState();
}

class ConferencePageState extends State<ConferencePage> {
  @override
  Widget build(BuildContext context) => AppScaffold(
        builder: (context) => DashboardPage(
            title: 'Conference',
            currentRouteName: ConferencePage.routeName,
            builder: (context) =>
                Center(child: NJTextSubheading('Coming soon')),
            thumbMenu: UserPageThumbMenu()),
      );
}
