import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../widgets/context_help/context_help.dart';
import '../../../../widgets/dashboard.dart';
import '../../office_dashboard/dashlets/user_dashboard_dashlet.dart';
import '../dashlets/conference_dashlet.dart';
import '../dashlets/contact_dashlet.dart';
import '../dashlets/limits_dashlet.dart';
import '../dashlets/office_dashboard.dart';
import '../dashlets/support_dashlet.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});
  static const RouteName routeName = RouteName('userdashboard');
  static const String title = 'User Dashbaord';

  static const Color dashletBackgroundColor = Colors.blueAccent;

  @override
  UserDashboardState createState() => UserDashboardState();
}

class UserDashboardState extends State<UserDashboard> {
  bool visible = false;

  @override
  Widget build(BuildContext context) => AppScaffold(
      builder: (context) => ContextHelp(
          title: const Text('Overview'),
          body: const Text('''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'''),
          highlight: false,
          child: buildDashBoard()));

  Widget buildDashBoard() => Column(
        children: [
          Expanded(
              child: Dashboard(heading: buildHeading(), rows: [
            buildRowOne(),
            buildRowTwo(),
            buildRowThree(),
            buildRowFour(),
            buildRowFive()
          ])),
        ],
      );

  Widget buildHeading() => const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text('Office: 03 8320 8100'), Text('Closing Time: 5:15pm')]);

  Row buildRowFour() => const Row(children: [
        UserDashboardDashlet(),
        // TeamDashboardDashlet(),
        ContextHelp(
          title: Text('Office Settings Help'),
          body: Text('''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'''),
          child: OfficeSettingsDashlet(),
        )
      ]);

  Row buildRowOne() => const Row(children: [
        SupportDashlet(),
        LimitsDashlet(),
      ]);

  Row buildRowTwo() => const Row(children: [
        ConferenceDashlet(),
      ]);

  Row buildRowThree() => const Row();

  Row buildRowFive() => const Row(children: [ContactDashlet()]);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('visible', visible));
  }
}
