import 'dart:async';

import 'package:completer_ex/completer_ex.dart';
import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:provider/provider.dart';

import '../../../../dao/entities/business_hours_for_day.dart';
import '../../../../dao/entities/override_hours.dart';
import '../../../../dao/entities/team.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../util/local_time.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../dashboard/selected_team.dart';
import '../dashboard/team_dashboard.dart';
import '../pages/team_business_hours_page.dart';

class BusinessHoursDashlet extends StatefulWidget {
  const BusinessHoursDashlet({super.key});
  @override
  State<StatefulWidget> createState() => BusinessHoursDashletState();
}

class BusinessHoursDashletState extends State<BusinessHoursDashlet> {
  DateTime asAt = DateTime.now();
  late Team team;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<SelectedTeam>(builder: (context, selectedTeam, _) {
      team = selectedTeam.team!;
      // setState(() => team = selectedTeam.team);

      return FutureBuilderEx<Hours>(
        future: loadHours,
        waitingBuilder: (context) => dashletBuilder(
            OverrideHours.defaults(null), BusinessHoursForDay(), asAt),
        errorBuilder: (context, error) => dashletBuilder(
            OverrideHours.defaults(null), BusinessHoursForDay(), asAt),
        builder: (context, hours) => dashletBuilder(
              hours!.overrideHours, hours.businessHours, asAt),
        debugLabel: 'Voicemail Dashlet',
      );
    });

  Future<Hours> loadHours() async {
    final completer = CompleterEx<Hours>();

    final overrideHours = await Repos().overrideHours.getByTeam(team);
    final businessHours = await Repos()
        .businessHoursForDay
        .getByGUID(team.getBusinessHoursByWeekDay(asAt.weekday).guid!);

    completer.complete(Hours(overrideHours!, businessHours));

    return completer.future;
  }

  Widget dashletBuilder(OverrideHours overrideHours,
      BusinessHoursForDay businessHours, DateTime asAt) {
    String openLabel;
    Color openColor;

    final open = isOpen(overrideHours, businessHours, asAt);
    if (open) {
      openLabel = 'Open';
      openColor = Colors.green;
    } else {
      openLabel = 'Closed';
      openColor = Colors.red;
    }
    return Dashlet(
      label: 'Business Hours',
      svgImage: const Svg('BusinessHours', height: Dashlet.height),
      targetRoute: TeamBusinessHoursPage.routeName,
      chipColor: openColor,
      chipText: openLabel,
      backgroundColor: TeamDashboard.dashletBackgroundColor,
    );
  }

  bool isOpen(OverrideHours overrideHours, BusinessHoursForDay businessHours,
      DateTime asAt) {
    bool isOpen;

    final overrideActive = overrideHours.isActiveNow(asAt, businessHours);

    final businessHoursOpen =
        businessHours.isOpenAt(LocalTime.fromDateTime(asAt));

    if (businessHoursOpen) {
      if (overrideActive) {
        isOpen = false;
      } else {
        isOpen = true;
      }
    } else {
      if (overrideActive) {
        isOpen = true;
      } else {
        isOpen = false;
      }
    }

    return isOpen;
  }
}

class Hours {

  Hours(this.overrideHours, this.businessHours);
  BusinessHoursForDay businessHours;
  OverrideHours overrideHours;
}
