import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:provider/provider.dart';

import '../../../../dao/entities/team.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../dialogs/dialog_selection.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../../../../widgets/theme/nj_text_themes.dart';
import '../dashboard/selected_team.dart';
import '../dashboard/team_dashboard.dart';

class SelectTeamDashlet extends StatefulWidget {
  const SelectTeamDashlet({super.key});

  @override
  State<StatefulWidget> createState() => SelectTeamDashletState();
}

class SelectTeamDashletState extends State<SelectTeamDashlet> {
  late SelectedTeam seletedTeam;

  @override
  Widget build(BuildContext context) {
    seletedTeam = Provider.of<SelectedTeam>(context);

    return FutureBuilderEx<String>(
      future: () => seletedTeam.teamName,
      waitingBuilder: (context) => buildDashlet(null),
      builder: (context, teamName) => buildDashlet(teamName),
    );
  }

  Dashlet buildDashlet(String? teamName) => Dashlet(
      label: 'Select Team',
      svgImage: buildContent(),
      chipColor: Colors.orange,
      chipText: teamName,
      onPressed: showTeams,
      backgroundColor: TeamDashboard.dashletBackgroundColor);

  Widget buildContent() => const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Svg(
              'select',
              height: Dashlet.iconHeightSmall,
              location: LOCATION.vaadin,
            ),
          ),
        ],
      );

  Future<void> showTeams() async {
    final team = await DialogSelection.show<Team>(
        context: context,
        title: 'Select Team',
        searchHint: '<team name>',
        searchLabel: 'Team',
        filterMatch: (filter, team) =>
            Future.value(team.name!.toLowerCase().contains(filter)),
        cardBuilder: (context, team, _) => NJTextLabel(team.name!),
        listLoader: () => Repos().team.getAll(force: true));

    seletedTeam.team = team;
  }
}
