import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../dao/entities/registration.dart';
import '../../widgets/no_app_bar_scaffold.dart';
import '../dashboards/dashboard_page.dart';

///
///This page is displayed when a users trial has expired.
class TrialExpiringPageSettings {
  TrialExpiringPageSettings({required this.registration});
  MobileRegistration registration;
}

class TrialExpiringPage extends StatefulWidget {
  const TrialExpiringPage({required this.settings, super.key});
  static const RouteName routeName = RouteName('/trialExpiringSoon');
  final TrialExpiringPageSettings settings;

  @override
  TrialExpiringPageState createState() => TrialExpiringPageState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<TrialExpiringPageSettings>('settings', settings));
  }
}

class TrialExpiringPageState extends State<TrialExpiringPage> {
  TrialExpiringPageState() {
    settings = widget.settings;
    // mobile = settings.progress.mobile;
    // validMobile = PhoneNumber.
    // isMobile(settings.progress.mobile.toNational());
  }
  late final TrialExpiringPageSettings settings;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => NoAppBarScaffold(
          child: DashboardPage(
        title: 'Trial Expiring Soon',
        currentRouteName: TrialExpiringPage.routeName,
        builder: (context) => buildBody(),
      ));

  /// TODO: add subscription options here.
  Widget buildBody() =>
      const SingleChildScrollView(child: Text('Trial will expire soon'));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<TrialExpiringPageSettings>('settings', settings));
  }
}
