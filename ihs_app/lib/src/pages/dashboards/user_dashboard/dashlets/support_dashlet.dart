import 'package:flutter/material.dart';

import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../pages/support_page.dart';

class SupportDashlet extends StatefulWidget {
  const SupportDashlet({super.key});

  @override
  State<StatefulWidget> createState() => SupportDashletState();
}

class SupportDashletState extends State<SupportDashlet> {
  @override
  Widget build(BuildContext context) => Dashlet(
        label: 'Support',
        svgImage: const Svg('Support', height: Dashlet.height),
        targetRoute: SupportPage.routeName);
}
