import 'package:flutter/material.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../widgets/blocking_ui.dart';
import '../../../../widgets/theme/nj_text_themes.dart';
import '../../../../widgets/wizard.dart';
import '../../../../widgets/wizard_step.dart';
import '../../dashboard_page.dart';
import '../dashboard/user_page_thumb_menu.dart';

class LimitsPage extends StatefulWidget {
  const LimitsPage({super.key});
  static const RouteName routeName = RouteName('/limitspage');

  @override
  LimitsPageState createState() => LimitsPageState();
}

class LimitsPageState extends State<LimitsPage> {
  LimitsPageState() {
    steps = buildSteps();
  }
  late List<WizardStep> steps;

  @override
  Widget build(BuildContext context) => AppScaffold(
        builder: (context) => DashboardPage(
            title: 'Limits',
            currentRouteName: LimitsPage.routeName,
            builder:
                // Center(child: ButtonPrimary(label: 'Limits Page', onPressed: lock)),
                (context) => Wizard(
                      initialSteps: steps,
                      onFinished: onFinished,
                    ),
            thumbMenu: UserPageThumbMenu()),
      );

  Future<void> lock() async {
    await BlockingUI().run<void>(
        () => Future<void>.delayed(const Duration(milliseconds: 1750)),
        label: 'Saving');
  }

  List<WizardStep> buildSteps() =>
      [PageOne(), PageTwo(), PageThree(), PageFour(), PageFive(), PageSix()];

  Future<void> onFinished(WizardCompletionReason reason) async {
    SQRouter().pop<void>();
  }
}

class PageOne extends WizardStep {
  PageOne() : super(title: 'Page One');

  @override
  Widget build(BuildContext context) => NJTextBody('Page 1');
}

class PageTwo extends WizardStep {
  PageTwo() : super(title: 'Page Two');
  @override
  Widget build(BuildContext context) => Column(children: [
        NJTextBody('Page 2'),
        NJTextBody('Page 2'),
        NJTextBody('Page 2'),
        NJTextBody('Page 2'),
        NJTextBody('Page 2'),
        NJTextBody('Page 2'),
        NJTextBody('Page 2'),
        NJTextBody('Page 2'),
        NJTextBody('Page 2'),
        NJTextBody('Page 2'),
        NJTextBody('Page 2'),
      ]);
}

class PageThree extends WizardStep {
  PageThree() : super(title: 'Page Three');
  @override
  Widget build(BuildContext context) => Column(children: [
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
      ]);
}

class PageFour extends WizardStep {
  PageFour() : super(title: 'Page Four');
  @override
  Widget build(BuildContext context) => Column(children: [
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
      ]);
}

class PageFive extends WizardStep {
  PageFive() : super(title: 'Page Four');
  @override
  Widget build(BuildContext context) => Column(children: [
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
      ]);
}

class PageSix extends WizardStep {
  PageSix() : super(title: 'Page Four');
  @override
  Widget build(BuildContext context) => Column(children: [
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
        NJTextBody('Page 3'),
      ]);
}
