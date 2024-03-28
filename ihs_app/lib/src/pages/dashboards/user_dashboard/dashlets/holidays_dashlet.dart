import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';

import '../../../../dao/bus/bus.dart';
import '../../../../dao/bus/bus_builder.dart';
import '../../../../dao/entities/leave.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../util/local_date.dart';
import '../../../../util/ref.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../pages/holidays_page.dart';

class HolidaysDashlet extends StatefulWidget {
  const HolidaysDashlet({super.key});

  @override
  State<StatefulWidget> createState() => HolidaysDashletState();
}

class HolidaysDashletState extends State<HolidaysDashlet> {
  late FutureRef<Leave?> leaveRef;
  @override
  void initState() {
    super.initState();

    leaveRef = FutureRef.withResolver(
        () async => Repos().leave.getByUser(Repos().user.viewAsUser));
  }

  @override
  Widget build(BuildContext context) => FutureBuilderEx<Ref<Leave?>>(
        future: () => leaveRef.future,
        waitingBuilder: (context) => buildDashlet(null),
        errorBuilder: (context, error) => buildDashlet(null),
        builder: (context, leave) => buildDashlet(leave),
        debugLabel: 'Holidays Dashlet',
      );

  Widget buildDashlet(Ref<Leave?>? leaveRef) =>
      BusBuilder<HolidayBusEvent>(builder: (context, event) {
        final asAt = LocalDate.today();
        var chipText = '';
        Color chipColor = Colors.yellow;

        if (event.action == BusAction.update) {
          leaveRef!.obj = event.instance!.leave.entity;
        }

        if (Ref.isNotNullOrEmpty(leaveRef!)) {
          final nextTransition = leaveRef.obj!.nextTransition(asAt);
          final inHolidays = leaveRef.obj!.inHolidays(asAt);

          if (inHolidays) {
            chipColor = Colors.red;
          }
          if (nextTransition != null) {
            chipText = nextTransition;
          }
          // chipText = leaveRef.obj.callForwardTarget.entity.toString();
        }

        return Dashlet(
            label: 'Holidays',
            svgImage: const Svg('Holidays', height: Dashlet.height),
            targetRoute: HolidaysPage.routeName,
            chipText: chipText,
            chipColor: chipColor);
      });
}
