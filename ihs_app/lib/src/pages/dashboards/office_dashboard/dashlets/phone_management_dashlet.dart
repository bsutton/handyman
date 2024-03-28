import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../../../dao/entities/did_forward.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../dashboard/office_dashboard.dart';
import '../pages/phone_no_list_page.dart';

class PhoneManagementDashlet extends StatefulWidget {
  const PhoneManagementDashlet({super.key});

  @override
  State<StatefulWidget> createState() => PhoneManagementDashletState();
}

class PhoneManagementDashletState extends State<PhoneManagementDashlet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilderEx<List<DIDForward>>(
        future: () async => Repos().didForward.getAll(),
        waitingBuilder: (context) => dashletBuilder([]),
        errorBuilder: (context, error) => dashletBuilder([]),
        builder: (context, didForwards) => dashletBuilder(didForwards!),
        debugLabel: 'Phone Management Dashlet',
      );

  Widget dashletBuilder(List<DIDForward> ownedPhoneNumbers) {
    String label;

    label = 'Phone Numbers (${ownedPhoneNumbers.length})';
    return Dashlet(
        label: label,
        svgImage: const Svg('PhoneNoManagement', height: Dashlet.height),
        targetRoute: PhoneNoListPage.routeName,
        alignment: DashletAlignment.left,
        flex: 2,
        backgroundColor: OfficeDashboard.dashletBackgroundColor);
  }

  Widget buildContent() => const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Svg('Phone Management', height: Dashlet.height),
          ),
        ],
      );
}
