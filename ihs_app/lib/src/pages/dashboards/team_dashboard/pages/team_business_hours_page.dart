import 'package:flutter/material.dart';
import 'package:future_builder_ex/future_builder_ex.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../dao/entities/business_hours_for_day.dart';
import '../../../../dao/entities/override_hours.dart';
import '../../../../dao/entities/team.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../dao/types/er.dart';
import '../../../../util/format.dart';
import '../../../../util/local_time.dart';
import '../../../../widgets/blocking_ui.dart';
import '../../../../widgets/empty.dart';
import '../../../../widgets/splash_effect.dart';
import '../../../../widgets/svg.dart';
import '../../../../widgets/theme/nj_text_themes.dart';
import '../../../../widgets/timepicker/time_picker.dart';
import '../../dashboard_page.dart';
import '../dashboard/selected_team.dart';
import '../dashboard/team_page_thumb_menu.dart';

class TeamBusinessHoursPage extends StatefulWidget {
  const TeamBusinessHoursPage({super.key});
  static const RouteName routeName = RouteName('teambusinesshourspage');

  @override
  TeamBusinessHoursPageState createState() => TeamBusinessHoursPageState();
}

class TeamBusinessHoursPageState extends State<TeamBusinessHoursPage> {
  TeamBusinessHoursPageState();
  DateTime asAt = DateTime.now();
  late Team team;
  late String timezoneName;

  late OverrideHours? overrideHours;

  late BusinessHoursForDay businessHoursForDay;

  String nextTransitionText = '';

  Future<void> loadData(BuildContext context) async {
    final selectedTeam = Provider.of<SelectedTeam>(context);
    team = selectedTeam.team!;
    final customer = await team.owner!.resolve;
    final region = await customer!.region!.resolve;
    overrideHours = await team.overrideHours!.resolve;
    timezoneName = region!.timezone.humanName;

    businessHoursForDay = await team.getByWeekDay(asAt.weekday);

    nextTransitionText = (await team.nextTransitionText)!;
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
        builder: (context) => DashboardPage(
            loadData: loadData,
            title: 'Business Hours',
            currentRouteName: TeamBusinessHoursPage.routeName,
            builder: (context) => buildPage(),
            thumbMenu: TeamPageThumbMenu()),
      );

  Widget buildPage() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [buildTimezone(team), ...buildNighSwitchStatus(team)]),
        FutureBuilderEx(
            future: () async => buildDayGrid(team),
            builder: (context, dayGrid) => dayGrid!),
        buildNextTransition(),
      ]);

  Widget buildTimezone(Team team) => NJTextNotice('Timezone: $timezoneName');

  List<Widget> buildNighSwitchStatus(Team team) {
    final result = <Widget>[];

    if (overrideHours != null) {
      if (overrideHours!.isOpenAt(asAt)) {
        final nightSwitchText =
            overrideHours!.getStatusDescription(asAt, businessHoursForDay);

        result.add(NJTextNotice('Night Switch: $nightSwitchText'));
      }
    }
    return result;
  }

  Widget buildNextTransition() => NJTextNotice(nextTransitionText);

  Future<Widget> buildDayGrid(Team team) async {
    final kids = <Widget>[];

    kids.addAll(buildHeading());
    kids.addAll(buildDay(await team.monday!.resolve));
    kids.addAll(buildDay(await team.tuesday!.resolve));
    kids.addAll(buildDay(await team.wednesday!.resolve));
    kids.addAll(buildDay(await team.thursday!.resolve));
    kids.addAll(buildDay(await team.friday!.resolve));
    kids.addAll(buildDay(await team.saturday!.resolve));
    kids.addAll(buildDay(await team.sunday!.resolve));

    return Expanded(
        child: GridView.count(
            crossAxisCount: 4, childAspectRatio: 2, children: kids));
  }

  List<Widget> buildHeading() => [
        buildColumnHeading('Open'),
        buildColumnHeading('Day'),
        buildColumnHeading('Opening'),
        buildColumnHeading('Closing')
      ];

  TextStyle columnHeadingStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  Center buildColumnHeading(String title) =>
      Center(child: Text(title, style: columnHeadingStyle));

  List<Widget> buildDay(BusinessHoursForDay? day) {
    if (day == null) {
      return [const Empty()];
    }
    return [
      buildOpenSwitch(day),
      buildDayName(day),
      buildOpening(day),
      buildClosing(day)
    ];
  }

  // we need a row to allow the switch to relax back to its standard width.
  Widget buildOpenSwitch(BusinessHoursForDay day) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Switch(
            value: day.open,
            onChanged: (value) {
              setState(() async {
                day.open = value;
                await BlockingUI().blockUntilFuture<ER<BusinessHoursForDay>>(
                  () => Repos().businessHoursForDay.update(day),
                  label: 'Saving',
                );
              });
            },
          )
        ],
      );

  // style: TextStyle(fontWeight: FontWeight.bold)));
  Widget buildDayName(BusinessHoursForDay day) =>
      Center(child: NJTextLabel(day.dayOfWeek.dayName()));

  Widget buildOpening(BusinessHoursForDay day) => SplashEffect(
      onTap: () async => showTimePicker(day, opening: true),
      child: Center(
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [buildSvg(), buildTime(day.openingTime)])));

  Widget buildSvg() => Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Svg('clock',
          location: LOCATION.vaadin,
          height: 16,
          width: 16,
          color: Theme.of(context).primaryColor));

  Widget buildClosing(BusinessHoursForDay day) => SplashEffect(
      onTap: () async => showTimePicker(day, opening: false),
      child: Center(
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [buildSvg(), buildTime(day.closingTime)])));

  Widget buildTime(LocalTime time) =>
      NJTextLabel(Format.localTime(time, 'h:mm a'));

  Future<void> showTimePicker(BusinessHoursForDay day,
      {required bool opening}) async {
    final heading = '${day.dayOfWeek.dayName()}'
        '${opening ? ' Opening ' : ' Closing'}'
        ' Time';

    final timeOfDayState = await TimePicker.show(
        context, heading, opening ? day.openingTime : day.closingTime);
    if (timeOfDayState != null) {
      if (opening) {
        day.updateOpeningTime(timeOfDayState);
      } else {
        day.updateClosingTime(timeOfDayState);
      }

      setState(() {
        BlockingUI().blockUntilFuture<ER<BusinessHoursForDay>>(
          () => Repos().businessHoursForDay.update(day),
          label: 'Saving',
        );
      });
    }
  }
}
