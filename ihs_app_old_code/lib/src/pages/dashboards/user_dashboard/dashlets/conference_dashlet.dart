import 'package:flutter/material.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../pages/conference_page.dart';

class ConferenceDashlet extends StatefulWidget {
  const ConferenceDashlet({super.key});

  @override
  State<StatefulWidget> createState() => ConferenceDashletState();
}

class ConferenceDashletState extends State<ConferenceDashlet> {
  @override
  Widget build(BuildContext context) => Dashlet(
      label: 'Conference',
      svgImage: const Svg('Conference', height: Dashlet.height),
      targetRoute: ConferencePage.routeName,
    );

  void pushRoute() {
    // SQRouter().pushNamed(ConferenceIndexPage.routeName);
  }
}
