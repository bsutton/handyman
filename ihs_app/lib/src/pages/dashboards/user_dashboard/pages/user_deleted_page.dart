import 'package:flutter/material.dart';

import '../../../../app/router.dart';
import '../../../../registration_wizard/registration_type_page.dart';
import '../../../../registration_wizard/state_machine/registration_fsm.dart';
import '../../../../widgets/no_app_bar_scaffold.dart';
import '../../../../widgets/theme/nj_button.dart';
import '../../../../widgets/theme/nj_text_themes.dart';
import '../../dashboard_page.dart';

class UserDeletedPage extends StatefulWidget {
  const UserDeletedPage({super.key});
  static const RouteName routeName = RouteName('/userdeletedpage');

  @override
  UserDeletedPageState createState() => UserDeletedPageState();
}

class UserDeletedPageState extends State<UserDeletedPage> {
  @override
  Widget build(BuildContext context) => NoAppBarScaffold(
      child: DashboardPage(
        title: 'User account Deleted',
        currentRouteName: UserDeletedPage.routeName,
        builder: (context) => Column(children: [
          Center(
              child: NJTextSubheading('Your user account has been deleted.')),
          NJButtonPrimary(
              label: 'Register',
              onPressed: () => RegistrationFSM().applyEvent(
                  OnForceRegistration(RegistrationType.notSelected)))
        ]),
      ),
    );
}
