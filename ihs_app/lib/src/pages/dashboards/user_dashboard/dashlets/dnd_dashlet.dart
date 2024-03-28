import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../../../dao/entities/dnd.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../pages/dnd_page.dart';

class DNDDashlet extends StatefulWidget {
  const DNDDashlet({super.key});

  @override
  State<StatefulWidget> createState() => DNDDashletState();
}

class DNDDashletState extends State<DNDDashlet> {
  late Future<DND?> dnd;
  @override
  void initState() {
    super.initState();

    // ignore: discarded_futures
    dnd = Repos().dnd.getByUser(Repos().user.viewAsUser!);
  }

  @override
  Widget build(BuildContext context) => FutureBuilderEx<DND>(
        future: () async => (await dnd)!,
        waitingBuilder: (context) => buildDashlet(null),
        errorBuilder: (context, error) => buildDashlet(null),
        builder: (context, dnd) => buildDashlet(dnd),
        debugLabel: 'DND Dashlet',
      );

  Widget buildDashlet(DND? dnd) => Dashlet(
      label: 'Do Not Disturb',
      svgImage: const Svg('DND', height: Dashlet.height),
      chipText: (dnd?.isDiverted() ?? false ? 'On' : null),
      chipColor: Colors.red,
      targetRoute: DNDPage.routeName);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Future<DND?>>('dnd', dnd));
  }
}
