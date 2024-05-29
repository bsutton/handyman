import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../dao/entities/registration.dart';
import '../../dao/types/phone_number.dart';
import '../../util/local_time.dart';
import '../../widgets/grayed_out.dart';
import '../../widgets/nj_text_field.dart';
import '../../widgets/no_app_bar_scaffold.dart';
import '../../widgets/theme/nj_text_themes.dart';
import '../dashboards/dashboard_page.dart';

///
///This page is displayed when a users trial has expired.
class SuspendedPageSettings {
  SuspendedPageSettings({required this.registration});
  MobileRegistration registration;
}

class SuspendedPage extends StatefulWidget {
  const SuspendedPage({required this.settings, super.key});
  static const RouteName routeName = RouteName('/suspended');
  final SuspendedPageSettings settings;

  @override
  SuspendedPageState createState() => SuspendedPageState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<SuspendedPageSettings>('settings', settings));
  }
}

class SuspendedPageState extends State<SuspendedPage> {
  SuspendedPageState() {
    settings = widget.settings;
    // mobile = settings.progress.mobile;
    // validMobile = PhoneNumber
    // .isMobile(settings.progress.mobile.toNational());
  }
  late final SuspendedPageSettings settings;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => NoAppBarScaffold(
          child: DashboardPage(
        title: 'Account Suspended',
        currentRouteName: SuspendedPage.routeName,
        builder: (context) => buildBody(),
      ));

  Widget buildBody() =>
      const SingleChildScrollView(child: Text('Account Suspended'));

  Widget buildButtons() =>
      const GrayedOut(grayedOut: false, child: Text('greyed out'));

  LocalTime getDefaultCustomPeriod() {
    final now = DateTime.now();

    final endTime = LocalTime.fromDateTime(now.add(const Duration(hours: 2)));

    // round minutes to nearest 5 minutes so the TimePicker 
    //shows a selected minute button.
    final minute = endTime.minute ~/ 5 * 5;
    return LocalTime(hour: endTime.hour, minute: minute);
  }

  Widget buildFields() => Column(children: [
        // TextNJNotice("Don't have time to complete the registration?"),
        const Center(
            child: NJTextNotice(
                'Enter your mobile no. and we will send you a reminder.')),
        TextFieldNJ(
          initialValue: 'phone',
          label: 'Mobile No.',
          keyboardType: TextInputType.phone,
          autofillHints: const [AutofillHints.telephoneNumberDevice],
          errorMessage: (value) => PhoneNumber.validate(value,
                  allowEmpty: false, fieldName: 'Mobile No.')
              .message,
        ),
        const NJTextNotice('When do you want to be reminded?'),
      ]);

  void resumeWizard() {
    SQRouter().pop<void>();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<SuspendedPageSettings>('settings', settings));
  }
}
