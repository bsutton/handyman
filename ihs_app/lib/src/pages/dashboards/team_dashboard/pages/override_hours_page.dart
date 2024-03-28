import 'package:flutter/material.dart';

import '../../../../app/app_scaffold.dart';
import '../../../../app/router.dart';
import '../../../../dao/bus/bus.dart';
import '../../../../dao/entities/business_hours_for_day.dart';
import '../../../../dao/entities/call_forward_target.dart';
import '../../../../dao/entities/override_hours.dart';
import '../../../../dao/repository/repos.dart';
import '../../../../dao/types/er.dart';
import '../../../../util/ansi_color.dart';
import '../../../../util/format.dart';
import '../../../../util/local_date.dart';
import '../../../../util/local_time.dart';
import '../../../../widgets/blocking_ui.dart';
import '../../../../widgets/call_forward/call_forward_panel_v2.dart';
import '../../../../widgets/mini_card/mini_row_state_provider.dart';
import '../../../../widgets/theme/nj_button.dart';
import '../../../../widgets/theme/nj_text_themes.dart';
import '../../../../widgets/theme/nj_theme.dart';
import '../../dashboard_page.dart';
import '../../user_dashboard/dashboard/user_page_thumb_menu.dart';

class OverrideHoursPageMiniRowState extends CallForwardMiniRowState {}

class OverrideHoursPage extends StatefulWidget {
  const OverrideHoursPage({super.key});

  static const RouteName routeName = RouteName('/overridehours');

  static const String provider = 'teamoverridehours';

  @override
  OverrideHoursPageState createState() => OverrideHoursPageState();
}

class OverrideHoursPageState extends State<OverrideHoursPage> {
  OverrideHoursPageState();
  static const int minInterval = 15;
  static const int rangeStartHour = 5;
  // static const int RANGE_END_HOUR = 21;

  late Team team;

  late ER<OverrideHours> erOverrideHours;
  late BusinessHoursForDay normalBusinessHours;
  DateTime asAt = DateTime.now();

  late RangeValues _range;

  String diversionDescription = '';

  DateTime? nextOpeningHours;

  late ER<CallForwardTarget> erCallForwardTarget;

  RangeValues initRange(OverrideHours overrideHours) {
    double start;
    double end;

    print(orange('${overrideHours.openAt}'));

    if (overrideHours.isActiveToday(LocalDate.fromDateTime(asAt))) {
      start = toInterval(overrideHours.openAt!).toDouble();
      end = toInterval(overrideHours.closeAt!).toDouble();
    } else {
      start = toInterval(normalBusinessHours.openingTime).toDouble();
      end = toInterval(normalBusinessHours.closingTime).toDouble();
    }

    print(orange('start $start'));
    return RangeValues(start, end);
  }

  Future<void> loadData() async {
    team = Repos().team.selectedTeam!.team!;

    asAt = DateTime.now();

    erOverrideHours = team.overrideHours!;
    await erOverrideHours.resolve;
    erCallForwardTarget = erOverrideHours.entity.callForwardTarget!;

    normalBusinessHours = await team.getByWeekDay(asAt.weekday);

    diversionDescription =
        await (await erCallForwardTarget.resolve)!.diversionDescription;

    nextOpeningHours = await team.getNextOpeningTime(LocalDate.today());

    _range = initRange(erOverrideHours.entity);
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
        builder: (context) => DashboardPage(
            loadData: (_) async => loadData(),
            title: 'Override Hours',
            currentRouteName: OverrideHoursPage.routeName,
            builder: (context) => buildBody(),
            thumbMenu: UserPageThumbMenu()),
      );

  Widget buildBody() =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        buildStatus(),
        MiniRowStateProvider<ER<CallForwardTarget>, CallForwardMiniRowState>(
          create: () => CallForwardMiniRowState(saveHandler: onSaveForwards),
          child: CallForwardPanelV2<OverrideHoursPageMiniRowState>(
            erCallForwardTarget,
            showIVR: false,
          ),
        ),
        const Spacer(),
        buildRange(),
        const Spacer(),
        buildReset()
      ]);

  ///
  /// This method is used to save any updates to the CallForwardTargets.
  /// The updated [CallForwardTarget] must be a copy of the original
  /// [CallForwardTarget] withe same GUID and id (e.g. use copyWith)
  ///
  Future<void> onSaveForwards(ER<CallForwardTarget> updated) async {
    await BlockingUI().run<void>(() async {
      // update the db.

      setState(() async {
        await erCallForwardTarget.resolve;
        assert(erCallForwardTarget.entity.guid == updated.guid,
            'something is wrong');
        final target = await updated.resolve;
        // update this pages reference.
        erCallForwardTarget.replace(target!);
        await Repos().callForwardTarget.update(target);

        // force the heading to update when the active forward has changed.
        setState(() {
          Bus().add<OverrideHoursBusEvent>(BusAction.update,
              instance: OverrideHoursBusEvent(erOverrideHours));
        });
      });
    });
  }

  void onChanged() {
    setState(() {
      // the active divert has changed so update the heading.
    });
  }

  Widget buildStatus() {
    String status;
    var target = '';
    final now = DateTime.now();
    final nowTime = LocalTime.fromDateTime(now);
    final color = Theme.of(context).textTheme.titleLarge!.color!;

    if (erOverrideHours.entity.inEarlyOpeningHours(now, normalBusinessHours)) {
      target = 'Calls are flowing normally.';
      status = 'The team has started early.';
    } else if (erOverrideHours.entity
        .inLateClosingHours(now, normalBusinessHours)) {
      status = 'The team is working late.';
      target = 'Calls are flowing normally.';
    }
    if (erOverrideHours.entity.inEarlyClosingHours(now, normalBusinessHours)) {
      status = 'The team has finished early.';
      target = 'Calls $diversionDescription';
    } else if (erOverrideHours.entity
        .inLateOpeningHours(now, normalBusinessHours)) {
      status = 'The team is starting late.';
      target = 'Calls $diversionDescription';
    } else {
      // we have no active overrides.
      if (normalBusinessHours.isOpenAt(nowTime)) {
        status = 'The team is taking calls.';
        target = 'Calls are flowing normally.';
      } else {
        status = 'The team has gone home for the night.';
        target = 'Calls $diversionDescription';
      }
    }

    return Padding(
        padding: const EdgeInsets.all(NJTheme.padding),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.only(top: NJTheme.padding),
              child: NJTextSubheading(target, color: color)),
          NJTextSubheading(status, color: color),
        ]));
  }

  DateTime? getNextOpeningHours() => nextOpeningHours;

  String getOneHour() =>
      Format.time(DateTime.now().add(const Duration(hours: 1)), '(h:mm a)');

  LocalTime getDefaultCustomPeriod() {
    final now = DateTime.now();

    final endTime = LocalTime.fromDateTime(now.add(const Duration(hours: 2)));

    // round minutes to nearest 5 minutes so the TimePicker shows a selected minute button.
    final minute = endTime.minute ~/ 5 * 5;
    return LocalTime(hour: endTime.hour, minute: minute);
  }

  Widget buildRange() {
    // 5am to 9pm - 16 hrs
    const intervals = 16 * 60 ~/ minInterval;

    return Column(
      children: <Widget>[
        buildRangeLabel(),
        SliderTheme(
            data: const SliderThemeData(
                minThumbSeparation: 2,
                rangeTickMarkShape: RoundRangeSliderTickMarkShape(),
                showValueIndicator: ShowValueIndicator.always,
                activeTrackColor: Colors.green,
                inactiveTrackColor: Colors.red

                // ...
                ),
            child: RangeSlider(
              values: _range,
              onChanged: onRangeChanged,
              labels: RangeLabels(buildStartRangeLabel(), buildEndRangeLabel()),
              divisions: intervals,
              max: intervals.toDouble(),
            )),
        NJTextLabel('Drag sliders to override opening hours.'),
        Padding(
          padding: const EdgeInsets.all(NJTheme.padding),
          child: NJUTextAncillary(
              'Opening times will reset to normal at the end of the day.'),
        )
      ],
    );
  }

  void onRangeChanged(RangeValues range) {
    setState(() async {
      _range = range;
      print(red('range: ${range.start}'));

      await BlockingUI().run<void>(() async {
        // set the new override
        erOverrideHours.entity.overrideDate = LocalDate.today();
        erOverrideHours.entity.openAt = toTime(range.start);
        erOverrideHours.entity.closeAt = toTime(range.end);
        await Repos().overrideHours.update(erOverrideHours.entity);
        print(green('range: ${erOverrideHours.entity.openAt}'));
        return Future.value();
      });
    });
  }

  int toInterval(LocalTime time) {
    var minutes = (time.hour - rangeStartHour) * 60 + time.minute;

    if (minutes < 0) {
      minutes = 0;
    }

    return minutes ~/ minInterval;
  }

  LocalTime toTime(double position) {
    final minutes = positionToMinutes(position);

    return LocalTime(hour: minutes ~/ 60, minute: (minutes % 60).toInt());
  }

  /// converts a position into the no. of minutes since midnight.
  double positionToMinutes(double position) =>
      (position + calcFirstPosition()) * minInterval;

  int calcFirstPosition() => rangeStartHour * (60 ~/ minInterval);

  String buildEndRangeLabel() => buildValueDisplay(_range.end);

  String buildStartRangeLabel() => buildValueDisplay(_range.start);

  String buildValueDisplay(double position) {
    position = position + (rangeStartHour * (60 ~/ minInterval));
    final minutes = (position * minInterval) % 60;
    var hours = (position * minInterval) / 60;

    var ampm = 'pm';

    if (hours < 12) {
      ampm = 'am';
    }

    if (hours > 12) {
      hours -= 12;
    }

    if (hours < 1) {
      hours = 12;
    }

    return '$hours.toInt().toString()}'
        ':'
        '${minutes.toInt().toString().padLeft(2, '0')}'
        ' $ampm';
  }

  Widget buildRangeLabel() => Center(
        child: Column(children: [
          NJTextLabel(normalBusinessHours.dayName()),
          NJTextLabel(
              ' Open at : ${buildStartRangeLabel()} - Close at: ${buildEndRangeLabel()}')
        ]),
      );

  Widget buildReset() =>
      NJButtonSecondary(label: 'Reset', onPressed: clearOverride);

  void clearOverride() {
    setState(() async {
      await BlockingUI().run<void>(() async {
        erOverrideHours.entity
            .reset(await team.getByWeekDay(DateTime.now().weekday));
        initRange(erOverrideHours.entity);
        await Repos().overrideHours.update(erOverrideHours.entity);
      });
    });
  }
}

class OverrideHoursBusEvent {
  OverrideHoursBusEvent(this.leave);
  ER<OverrideHours> leave;
}
