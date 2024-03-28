import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../dao/entities/mobile_registration.dart';
import '../../widgets/no_app_bar_scaffold.dart';
import '../dashboards/dashboard_page.dart';

///
///This page is displayed when a users trial has expired.
class TrialExpiredPageSettings {
  TrialExpiredPageSettings({required this.registration});
  MobileRegistration registration;
}

class TrialExpiredPage extends StatefulWidget {
  const TrialExpiredPage({required this.settings, super.key});
  static const RouteName routeName = RouteName('/trialExpired');
  final TrialExpiredPageSettings settings;

  @override
  TrialExpiredPageState createState() => TrialExpiredPageState();
}

class TrialExpiredPageState extends State<TrialExpiredPage> {
  TrialExpiredPageState() {
    settings = widget.settings;
    // mobile = settings.progress.mobile;
    // validMobile = PhoneNumber.isMobile(settings.progress.mobile.toNational());
  }
  late final TrialExpiredPageSettings settings;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => NoAppBarScaffold(
          child: DashboardPage(
        title: 'Trial Expired',
        currentRouteName: TrialExpiredPage.routeName,
        builder: (context) => buildBody(),
      ));

  // TODO: add button to re-register which is requried as we detach
  // the DIDs etc once the trial expires.
  Widget buildBody() =>
      const SingleChildScrollView(child: Text('Trial has expired.'));
}
