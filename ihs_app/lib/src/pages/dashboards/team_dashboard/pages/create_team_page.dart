import 'package:flutter/material.dart' hide Action;
import 'package:strings/strings.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../dao/entities/team.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../util/quick_snack.dart';
import '../../../../widgets/blocking_ui.dart';
import '../../../../widgets/theme/nj_button.dart';
import '../../dashboard_page.dart';
import '../dashboard/team_page_thumb_menu.dart';

class CreateTeamPage extends StatefulWidget {
  const CreateTeamPage({super.key});
  static const RouteName routeName = RouteName('/createteam');

  @override
  CreateTeamPageState createState() => CreateTeamPageState();
}

class CreateTeamPageState extends State<CreateTeamPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  String teamName = '';

  @override
  Widget build(BuildContext context) => AppScaffold(
        builder: (context) => DashboardPage(
            title: 'Create Team',
            currentRouteName: CreateTeamPage.routeName,
            builder: (context) => buildLayout(),
            thumbMenu: TeamPageThumbMenu()),
      );

  Widget buildLayout() =>
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Form(key: formKey, child: Column(children: [buildTeamNameField()])),
        buildButtons(),
      ]);

  TextFormField buildTeamNameField() => TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.supervised_user_circle),
        labelText: 'Team Name',
      ),
      onSaved: (value) => teamName = value?.trim() ?? '',
      validator: (value) {
        if (Strings.isBlank(value)) {
          return 'Team Name must not be empty.';
        } else {
          return null;
        }
      });

  Widget buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          NJButtonSecondary(
            label: 'Cancel',
            onPressed: () => SQRouter().pop<void>(),
          ),
          NJButtonPrimary(label: 'OK', onPressed: onSave)
        ],
      );

  Future<void> onSave() async {
    if (formKey.currentState?.validate.call() ?? false) {
      formKey.currentState?.save();

      final user = await Repos().user.getByGUID(Repos().user.loggedInUserGUID!);
      final owner = user.owner;
      final team = Team.forInsert(); // Team.withDefaults(owner, teamName);
      team.owner = owner;
      team.name = teamName;
      final erTeam = Repos().team.insert(team);

      await BlockingUI().blockUntilFuture<void>(() => erTeam,
          onError: (e) => QuickSnack().error(context, e.toString()),
          onDone: (_) => SQRouter().pop<void>());
    }
  }
}
