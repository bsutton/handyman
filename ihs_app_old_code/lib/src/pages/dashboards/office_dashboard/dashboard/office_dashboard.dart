import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../widgets/dashboard.dart';
import '../../../../widgets/empty.dart';
import '../../user_dashboard/dashlets/office_dashboard.dart';
import '../dashlets/about_dashlet.dart';
import '../dashlets/contact_dashlet.dart';
import '../dashlets/user_dashboard_dashlet.dart';
import '../dashlets/users_dashlet.dart';

class OfficeDashboard extends StatefulWidget {
  const OfficeDashboard({super.key});
  static const RouteName routeName = RouteName('OfficeDashboard');
  static const String title = 'User Dashbaord';

  static const Color dashletBackgroundColor = Colors.teal;

  @override
  OfficeDashboardState createState() => OfficeDashboardState();
}

class OfficeDashboardState extends State<OfficeDashboard> {
  bool visible = false;

  @override
  Widget build(BuildContext context) =>
      AppScaffold(builder: (context) => buildDashBoard());

  Widget buildDashBoard() => Dashboard(heading: buildHeading(), rows: [
        buildRowOne(),
        buildRowTwo(),
        buildRowThree(),
        buildRowFour(),
        buildRowFive(),
      ]);

  Widget buildHeading() => const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text('Office: 03 8320 8100'), Text('Closing Time: 5:15pm')]);

  Row buildRowOne() => const Row(children: [
        AboutDashlet(),
      ]);

  Row buildRowTwo() => const Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 2, // The dashlets in the next column should be
                // twice as wide.
                child: Column(children: [Empty()]))
          ]);

  Row buildRowThree() => const Row(children: [
        UsersDashlet(),
        //  SendInviteDashlet()
      ]);

  Row buildRowFour() => const Row(children: [
        UserDashboardDashlet(),
        // TeamDashboardDashlet(),
        OfficeSettingsDashlet(),
      ]);

  Row buildRowFive() => const Row(children: [ContactDashlet()]);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('visible', visible));
  }
}
