import 'package:flutter/material.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../dashboard_page.dart';
import '../dashboard/user_page_thumb_menu.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});
  static const RouteName routeName = RouteName('/supportpage');

  @override
  SupportPageState createState() => SupportPageState();
}

class SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) => AppScaffold(
      builder: (context) => DashboardPage(
          title: 'Support',
          currentRouteName: SupportPage.routeName,
          builder: (context) => const Center(child: Text('Support Page')),
          thumbMenu:  UserPageThumbMenu()),
    );
}
