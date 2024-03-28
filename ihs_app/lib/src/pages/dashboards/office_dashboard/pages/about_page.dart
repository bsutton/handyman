import 'package:flutter/material.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../dashboard_page.dart';
import '../dashboard/office_page_thumb_menu.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});
  static const RouteName routeName = RouteName('aboutpage');

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) => AppScaffold(
      builder: (context) => DashboardPage(
          title: 'About Us',
          currentRouteName: AboutPage.routeName,
          builder: (context) => const Center(child: Text('About Page')),
          thumbMenu:  OfficePageThumbMenu()),
    );
}
