import 'package:flutter/material.dart';
import 'package:strings/strings.dart';

import '../../../../app/router.dart';
import '../../../../dao/entities/team.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../widgets/theme/nj_button.dart';
import '../../../../widgets/theme/nj_text_themes.dart';
import '../../dashboard_page.dart';
import '../dashboard/team_page_thumb_menu.dart';

class TeamSettingsPage extends StatefulWidget {
  const TeamSettingsPage({super.key});
  static const RouteName routeName = RouteName('/teamsettings');

  @override
  TeamSettingsPageState createState() => TeamSettingsPageState();
}

class TeamSettingsPageState extends State<TeamSettingsPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  late Team team;

  Future<void> loadData() async {
    team = Repos().team.selectedTeam!.team!;
  }

  @override
  Widget build(BuildContext context) => DashboardPage(
      loadData: (context) async => loadData(),
      title: 'Team',
      currentRouteName: TeamSettingsPage.routeName,
      builder: (context) => buildLayout(),
      thumbMenu: TeamPageThumbMenu());

  Widget buildLayout() =>
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Form(
            key: formKey,
            child: Column(children: [
              buildTeamNameField(),
              buildLocationField(),
              buildWrapTimeField(),
              buildRotationField(),
              buildMusicOnHoldField()
            ])),
        buildButtons(),
      ]);

  TextFormField buildTeamNameField() => TextFormField(
      decoration: const InputDecoration(
        icon: Icon(Icons.supervised_user_circle),
        labelText: 'Team Name',
      ),
      onSaved: (value) => team.name = value,
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

  void onSave() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      SQRouter().pop(team);
    }
  }

  Widget buildLocationField() => NJTextLabel('Location');

  Widget buildWrapTimeField() => NJTextLabel('Wrap Time');

  Widget buildRotationField() => NJTextLabel('Call Rotation');

  Widget buildMusicOnHoldField() => NJTextLabel('Music On Hold');
}
