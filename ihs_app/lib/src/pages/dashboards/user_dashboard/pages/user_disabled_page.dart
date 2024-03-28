import 'package:flutter/material.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../widgets/theme/nj_text_themes.dart';
import '../../dashboard_page.dart';

class UserDisabledPage extends StatefulWidget {
  const UserDisabledPage({super.key});
  static const RouteName routeName = RouteName('/userdisabledpage');

  @override
  UserDisabledPageState createState() => UserDisabledPageState();
}

class UserDisabledPageState extends State<UserDisabledPage> {
  @override
  Widget build(BuildContext context) => AppScaffold(
      builder: (context) => DashboardPage(
        title: 'User account Disabled',
        currentRouteName: UserDisabledPage.routeName,
        builder: (context) => Center(
            child: NJTextSubheading('Your user account has been disabled')),
      ),
    );
}
