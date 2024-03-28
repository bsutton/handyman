import 'package:flutter/material.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../../user_dashboard/dashboard/user_dashboard.dart';

class UserDashboardDashlet extends StatefulWidget {
  const UserDashboardDashlet({super.key});

  @override
  State<StatefulWidget> createState() => UserDashboardDashletState();
}

class UserDashboardDashletState extends State<UserDashboardDashlet> {
  @override
  Widget build(BuildContext context) => Dashlet(
      heroTag: 'UserDashboard',
      label: 'User',
      svgImage: buildContent(),
      targetRoute: UserDashboard.routeName,
    );

  Widget buildContent() => const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(child: Svg('Dashboard', height: Dashlet.height / 2)),
      ],
    );
}
