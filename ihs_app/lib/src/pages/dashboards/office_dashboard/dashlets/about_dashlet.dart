import 'package:flutter/material.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../dashboard/office_dashboard.dart';
import '../pages/about_page.dart';

class AboutDashlet extends StatefulWidget {
  const AboutDashlet({super.key});

  @override
  State<StatefulWidget> createState() => AboutDashletState();
}

class AboutDashletState extends State<AboutDashlet> {
  @override
  Widget build(BuildContext context) => Dashlet(
        label: 'About',
        svgImage: const Svg('AboutUs', height: Dashlet.height),
        targetRoute: AboutPage.routeName,
        backgroundColor: OfficeDashboard.dashletBackgroundColor);
}
