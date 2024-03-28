import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../dao/entities/team.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../widgets/dashboard.dart';
import '../../../../widgets/theme/nj_text_themes.dart';
import '../../office_dashboard/dashlets/team_dashboard_dashlet.dart';
import '../../office_dashboard/dashlets/user_dashboard_dashlet.dart';
import '../../user_dashboard/dashlets/office_dashboard.dart';
import '../dashlets/business_hours.dart';
import '../dashlets/contact_dashlet.dart';
import '../dashlets/create_team.dart';
import '../dashlets/override_hours.dart';
import '../dashlets/select_team.dart';
import '../dashlets/team_members.dart';
import '../dashlets/team_settings.dart';
import 'selected_team.dart';

class TeamDashboard extends StatefulWidget {
  const TeamDashboard({super.key});
  static const RouteName routeName = RouteName('TeamDashboard');
  static const String title = 'Team Dashbaord';

  static const Color dashletBackgroundColor = Colors.purpleAccent;

  @override
  TeamDashboardState createState() => TeamDashboardState();
}

class TeamDashboardState extends State<TeamDashboard> {
  bool visible = false;

  @override
  Widget build(BuildContext context) =>
      AppScaffold(builder: (context) => buildDashBoard());

  Widget buildDashBoard() => FutureBuilderEx<Team>(
        future: () async => (await Repos().team.primary)!,
        builder: (context, team) => Dashboard(heading: buildHeading(), rows: [
          buildRowThree(),
          buildRowTwo(),
          buildRowOne(),
          buildRowFour(),
          buildRowFive(),
        ]),
      );

  Widget buildHeading() => Consumer<SelectedTeam>(
        builder: (context, selectedTeam, _) => FutureBuilderEx<String>(
          future: () => selectedTeam.teamName,
          builder: (context, teamName) => NJTextSubheading('Team: $teamName'),
        ),
      );

  Row buildRowThree() => const Row(children: [
        SelectTeamDashlet(),
        CreateTeamDashlet(),
      ]);

  // crossAxisAlignment: CrossAxisAlignment.stretch,
  //   Expanded(
  //       flex: 2, // The dashlets in the next column should be twice as wide.
  //       child:Container(child:
  //           Column(
  //             mainAxisSize: MainAxisSize.max,
  //             children: [

  //               BusinessHoursDashlet(), OutOfHoursDashlet()
  //             ])))
  // ]);
  Row buildRowOne() =>
      const Row(children: [BusinessHoursDashlet(), OverrideHoursDashlet()]);

  Row buildRowTwo() =>
      const Row(children: [TeamMembersDashlet(), TeamSettingsDashlet()]);

  Row buildRowFour() => const Row(children: [
        UserDashboardDashlet(),
        TeamDashboardDashlet(),
        OfficeSettingsDashlet(),
      ]);

  Row buildRowFive() => const Row(children: [ContactDashlet()]);
}
