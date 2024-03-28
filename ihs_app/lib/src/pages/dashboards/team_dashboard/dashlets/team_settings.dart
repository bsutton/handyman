import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../dashboard/selected_team.dart';
import '../dashboard/team_dashboard.dart';
import '../pages/team_settings_page.dart';

class TeamSettingsDashlet extends StatefulWidget {
  const TeamSettingsDashlet({super.key});

  @override
  State<StatefulWidget> createState() => TeamSettingsDashletState();
}

class TeamSettingsDashletState extends State<TeamSettingsDashlet> {
  @override
  Widget build(BuildContext context) => Consumer<SelectedTeam>(
        builder: (context, selectedTeam, _) => Dashlet(
            label: 'Team',
            svgImage: const Svg('TeamSettings', height: Dashlet.height),
            targetRoute: TeamSettingsPage.routeName,
            alignment: DashletAlignment.left,
            backgroundColor: TeamDashboard.dashletBackgroundColor),
      );
}
