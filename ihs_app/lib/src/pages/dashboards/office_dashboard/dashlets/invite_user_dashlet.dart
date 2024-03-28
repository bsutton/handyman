import 'package:flutter/material.dart';

import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../dashboard/office_dashboard.dart';
import '../pages/user_invite/user_invite_page.dart';

class SendInviteDashlet extends StatefulWidget {
  const SendInviteDashlet({super.key});
  @override
  State<StatefulWidget> createState() => SendInviteDashletState();
}

class SendInviteDashletState extends State<SendInviteDashlet> {
  @override
  Widget build(BuildContext context) => Dashlet(
        label: 'Invite',
        svgImage: const Svg('Invite', height: Dashlet.height),
        targetRoute: UserInvitePage.routeName,
        backgroundColor: OfficeDashboard.dashletBackgroundColor);
}
