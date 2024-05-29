import 'package:flutter/material.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../../office_dashboard/dashboard/office_dashboard.dart';

class OfficeSettingsDashlet extends StatefulWidget {
  const OfficeSettingsDashlet({super.key});

  @override
  State<StatefulWidget> createState() => OfficeSettingsDashletState();
}

class OfficeSettingsDashletState extends State<OfficeSettingsDashlet> {
  @override
  Widget build(BuildContext context) => Dashlet(
      label: 'Office',
      heroTag: 'OfficeDashboard',
      svgImage: buildContent(),
      targetRoute: OfficeDashboard.routeName,
      replaceRoute: true,
      backgroundColor: OfficeDashboard.dashletBackgroundColor,
    );

  Widget buildContent() => const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(child: Svg('Settings', height: Dashlet.height / 2)),
      ],
    );
}
