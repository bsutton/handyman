import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app/router.dart';
import '../dialogs/dialog_question.dart';
import '../widgets/no_app_bar_scaffold.dart';
import '../widgets/theme/nj_button.dart';
import '../widgets/theme/nj_text_themes.dart';
import 'dashboards/dashboard_page.dart';

/// We use this page when some unexpected error occurs that we don't
/// know how to recover from.
///
/// TODO: work out what options this page should contain.
///
class ErrorPage extends StatefulWidget {
  const ErrorPage({required this.cause, super.key});
  static const RouteName routeName = RouteName('/errorpage');
  final String cause;

  @override
  ErrorPagePageState createState() => ErrorPagePageState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('cause', cause));
  }
}

class ErrorPagePageState extends State<ErrorPage> {
  @override
  @override
  Widget build(BuildContext context) => NoAppBarScaffold(
          child: DashboardPage(
        title: 'Error',
        currentRouteName: ErrorPage.routeName,
        builder: (context) => buildBody(),
      ));

  Widget buildBody() => Column(
        children: [
          NJTextSubheading('An unexpected error occured.'),
          NJTextBody(widget.cause),
          NJUTextAncillary('Restart ${SquarePhoneApp.name} and try again.'),
          NJButtonPrimary(
              label: 'Register', onPressed: () async => reregister(context))
        ],
      );

  Future<void> reregister(BuildContext context) async {
    final result = await DialogQuestion.show(context, 'Re Register.', '''
Are you sure you want to register from scratch? All your settings will be lost.''');

    if (result == DialogQuestionResult.yes) {
      // RegistrationFSM()
      //     .applyEvent(OnForceRegistration(RegistrationType.notSelected));
    }
  }
}

class SquarePhoneApp {
  static const String name = 'Handyman';
}
