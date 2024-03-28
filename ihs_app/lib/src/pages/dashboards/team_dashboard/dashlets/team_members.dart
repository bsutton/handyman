import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../dashboard/selected_team.dart';
import '../dashboard/team_dashboard.dart';
import '../pages/team_members_page.dart';

class TeamMembersDashlet extends StatefulWidget {
  const TeamMembersDashlet({super.key});

  @override
  State<StatefulWidget> createState() => TeamMembersDashletState();
}

class TeamMembersDashletState extends State<TeamMembersDashlet> {
  @override
  Widget build(BuildContext context) => Consumer<SelectedTeam>(
        builder: (context, selectedTeam, _) {
          var hasMembers = false;
          var memberCount = 0;
          hasMembers = selectedTeam.team!.hasMembers();
          memberCount = selectedTeam.team!.members.length;

          return Dashlet(
              label: 'Team Members ($memberCount)',
              svgImage: const Svg('TeamMembers', height: Dashlet.height),
              targetRoute: TeamMembersPage.routeName,
              alignment: DashletAlignment.left,
              chipColor: Colors.blue,
              // TODO: determine which team members can take calls right now!
              chipText: (hasMembers ? 'Active: $memberCount' : null),
              flex: 2,
              backgroundColor: TeamDashboard.dashletBackgroundColor);
        },
      );
}
