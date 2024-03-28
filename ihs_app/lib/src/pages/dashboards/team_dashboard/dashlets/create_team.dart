import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../dao/entities/team.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../dashboard/team_dashboard.dart';
import '../pages/create_team_page.dart';

class CreateTeamDashlet extends StatefulWidget {
  const CreateTeamDashlet({super.key});

  @override
  State<StatefulWidget> createState() => CreateTeamDashletState();
}

class CreateTeamDashletState extends State<CreateTeamDashlet> {
  @override
  Widget build(BuildContext context) => Dashlet(
      label: 'Create Team',
      svgImage: buildContent(),
      onPressed: pushRoute,
      backgroundColor: TeamDashboard.dashletBackgroundColor);

  Future<void> pushRoute() async {
    await SQRouter().push<Team>(const CreateTeamPage());
  }

  Widget buildContent() => const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Svg('New', height: Dashlet.iconHeightSmall),
          ),
        ],
      );
}
