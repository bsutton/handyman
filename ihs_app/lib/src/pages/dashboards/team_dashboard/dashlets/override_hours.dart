import 'dart:async';

import 'package:completer_ex/completer_ex.dart';
import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:provider/provider.dart';

import '../../../../dao/entities/business_hours_for_day.dart';
import '../../../../dao/entities/override_hours.dart';
import '../../../../dao/entities/team.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../widgets/dashlet.dart';
import '../../../../widgets/svg.dart';
import '../dashboard/selected_team.dart';
import '../dashboard/team_dashboard.dart';
import '../pages/override_hours_page.dart';

class OverrideHoursDashlet extends StatefulWidget {
  const OverrideHoursDashlet({super.key});

  @override
  State<StatefulWidget> createState() => OverrideHoursDashletState();
}

class OverrideHoursDashletState extends State<OverrideHoursDashlet> {
  DateTime asAt = DateTime.now();
  late Future<void> dataLoader;
  late Team team;

  late Future<BusinessHoursForDay> businessHours;
  late Future<OverrideHours?> overrideHours;
  @override
  void initState() {
    super.initState();
  }

  Future<void> loadData() async {
    final done = CompleterEx<void>();
    dataLoader = done.future;

    team = Repos().team.selectedTeam!.team!;
    businessHours = loadBusinessHours();

    overrideHours = Repos().overrideHours.getByTeam(team);

    await Future.wait([businessHours, overrideHours])
        .then((_) => done.complete());
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<SelectedTeam>(builder: (context, selectedTeam, _) {
        team = selectedTeam.team!;

        return FutureBuilderEx<BusinessHoursForDay>(
          future: () async {
            await loadData();
            return businessHours;
          },
          waitingBuilder: (context) => dashletBuilder(null, asAt),
          errorBuilder: (context, error) => dashletBuilder(null, asAt),
          builder: (context, businessHours) =>
              dashletBuilder(businessHours, asAt),
          debugLabel: 'Override Hours Dashlet',
        );
      });

  Future<BusinessHoursForDay> loadBusinessHours() {
    final completer = CompleterEx<BusinessHoursForDay>();
    Repos()
        .businessHoursForDay
        .getByGUID(team.getBusinessHoursByWeekDay(asAt.weekday).guid!)
        .then(completer.complete);

    return completer.future;
  }

  Widget dashletBuilder(BusinessHoursForDay? businessHours, DateTime asAt) =>
      FutureBuilderEx<OverrideHours>(
        future: () async => (await overrideHours)!,
        waitingBuilder: (context) => dashlet('loading'),
        errorBuilder: (context, error) => dashlet('$error'),
        builder: (context, overrideHours) {
          final isActive = overrideHours!.isActiveNow(asAt, businessHours);
          final active = (isActive ? 'Active' : null);
          return dashlet(active!);
        },
        debugLabel: 'Override Hours Dashlet',
      );

  Widget dashlet(String active) => Dashlet(
      label: 'Override Hours',
      svgImage: const Svg('OverrideHours', height: Dashlet.height),
      targetRoute: OverrideHoursPage.routeName,
      chipColor: Colors.green,
      chipText: active,
      backgroundColor: TeamDashboard.dashletBackgroundColor);
}
