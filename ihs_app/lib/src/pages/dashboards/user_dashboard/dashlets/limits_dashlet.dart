import 'package:flutter/material.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../pages/limits_page.dart';

class LimitsDashlet extends StatefulWidget {
  const LimitsDashlet({super.key});

  @override
  State<StatefulWidget> createState() => LimitsDashletState();
}

class LimitsDashletState extends State<LimitsDashlet> {
  @override
  Widget build(BuildContext context) => Dashlet(
      label: 'Limits',
      svgImage: const Svg('Limits', height: Dashlet.height),
      targetRoute: LimitsPage.routeName,
    );
}
