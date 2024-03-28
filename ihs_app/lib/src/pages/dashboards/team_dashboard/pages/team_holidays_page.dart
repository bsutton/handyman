import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../dashboard_page.dart';
import '../dashboard/team_page_thumb_menu.dart';

class TeamHolidaysPage extends StatefulWidget {
  const TeamHolidaysPage.teamHolidaysPage({super.key});
  static const RouteName routeName = RouteName('teamholidays');

  @override
  TeamHolidaysPageState createState() => TeamHolidaysPageState();
}

class TeamHolidaysPageState extends State<TeamHolidaysPage> {
  @override
  Widget build(BuildContext context) => DashboardPage(
      title: 'Team Holidays',
      currentRouteName: TeamHolidaysPage.routeName,
      builder: (context) => const Center(child: Text('Office Holidays Page')),
      thumbMenu: TeamPageThumbMenu());
}
