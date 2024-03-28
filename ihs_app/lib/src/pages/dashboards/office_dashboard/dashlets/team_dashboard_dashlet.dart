import 'package:flutter/material.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../../team_dashboard/dashboard/team_dashboard.dart';

class TeamDashboardDashlet extends StatefulWidget {
  const TeamDashboardDashlet({super.key});

  @override
  State<StatefulWidget> createState() => TeamDashboardDashletState();
}

class TeamDashboardDashletState extends State<TeamDashboardDashlet> {
  @override
  Widget build(BuildContext context) => Dashlet(
        label: 'Team',
        heroTag: 'TeamDashboard',
        svgImage: buildContent(),
        flex: 2,
        targetRoute: TeamDashboard.routeName,
        replaceRoute: true,
        backgroundColor: TeamDashboard.dashletBackgroundColor);

  Widget buildContent() => const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(child: Svg('Settings', height: Dashlet.height / 2)),
      ],
    );
}
