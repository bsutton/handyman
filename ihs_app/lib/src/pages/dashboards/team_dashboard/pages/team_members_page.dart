import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../dao/entities/team.dart';
import '../../../../dao/entities/user.dart';
import '../../../../dao/repository/actions/action_team_update_members.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../dao/transaction/api/retry/retry_data.dart';
import '../../../../dao/transaction/transaction_factory.dart';
import '../../../../dao/types/er.dart';
import '../../../../util/quick_snack.dart';
import '../../../../widgets/alignment.dart';
import '../../../../widgets/blocking_ui.dart';
import '../../../../widgets/multi_select.dart';
import '../../../../widgets/theme/nj_button.dart';
import '../../../../widgets/theme/nj_text_themes.dart';
import '../../dashboard_page.dart';
import '../dashboard/team_page_thumb_menu.dart';

class TeamMembersPage extends StatefulWidget {
  const TeamMembersPage({super.key});
  static const RouteName routeName = RouteName('teammembers');

  @override
  TeamMembersPageState createState() => TeamMembersPageState();
}

class TeamMembersPageState extends State<TeamMembersPage> {
  List<SelectableUser> available = [];
  late Team team;

  Future<void> loadData() async {
    team = Repos().team.selectedTeam!.team!;
    final users = await Repos().user.getAll();

    available.clear();
    await Future.forEach<User>(users, (user) async {
      available.add(SelectableUser(user,
          selected: team.hasMember(ER.fromGUID(user.guid))));
    });
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
        builder: (context) => DashboardPage(
            loadData: (context) async => loadData(),
            title: 'Team Members',
            currentRouteName: TeamMembersPage.routeName,
            builder: (context) => buildLayout(),
            thumbMenu: TeamPageThumbMenu()),
      );

  Widget buildLayout() {
    final selected = available.where((user) => user.selected).length;

    return Column(children: [
      Center(child: NJTextHeadline('Team: ${team.name}')),
      Left(child: NJTextSubheading('Select Colleagues')),
      Right(child: NJTextNotice('Selected: $selected')),
      Expanded(
          child: MultiSelect(
        items: available,
        selectedIcon: Icon(
          Icons.supervised_user_circle,
          color: Theme.of(context).primaryColorDark,
        ),
        nonSelectedIcon: const Icon(Icons.person),
        selectedBackGroundColor: Theme.of(context).primaryColorLight,
        //  onChanged: () => setState(() {})
      )),
      Right(child: NJButtonPrimary(label: 'Done', onPressed: close))
    ]);
  }

  Future<void> close() async {
    // update the list of team members
    team.members = available
        .where((selectableUser) => selectableUser.selected)
        .map((selectableUser) => ER(selectableUser.user));

    final create = TransactionFactory.addAction<void>(
        ActionTeamUpdateMembers(team, RetryData.defaultRetry));

    await BlockingUI().blockUntilFuture<void>(() => create,
        onError: (e) => QuickSnack().error(context, e.toString()),
        onDone: (_) => SQRouter().pop<void>(),
        label: 'Saving');
  }
}

class SelectableUser extends Selectable {
  SelectableUser(this.user, {bool selected = false}) {
    super.selected = selected;
  }
  User user;

  @override
  String get title => user.fullname;
}
