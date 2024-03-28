import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../../../dao/entities/user.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../../../user/user_index_page.dart';
import '../dashboard/office_dashboard.dart';

class UsersDashlet extends StatefulWidget {
  const UsersDashlet({super.key});

  static String? routeName;
  @override
  State<StatefulWidget> createState() => UsersDashletState();
}

class UsersDashletState extends State<UsersDashlet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilderEx<List<User>>(
        future: () async => Repos().user.getAll(),
        waitingBuilder: (context) => buildDashlet('Users (?)'),
        errorBuilder: (context, error) => buildDashlet('Users (?)'),
        builder: (context, users) => buildDashlet('Users (${users!.length})'),
        debugLabel: 'User Dashlet',
      );

  Widget buildDashlet(String label) => Dashlet(
      label: label,
      svgImage: const Svg('Users', height: Dashlet.height),
      targetRoute: UserIndexPage.routeName,
      alignment: DashletAlignment.left,
      flex: 2,
      backgroundColor: OfficeDashboard.dashletBackgroundColor);
}
