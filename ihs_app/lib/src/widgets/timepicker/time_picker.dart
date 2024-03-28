import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/router.dart';
import '../../util/local_time.dart';
import '../dialog_heading.dart';
import '../theme/nj_button.dart';
import '../theme/nj_text_themes.dart';
import '../theme/nj_theme.dart';
import 'am_pm_button.dart';
import 'hour_button.dart';
import 'minute_button.dart';
import 'moon_phase.dart';
import 'time_of_day_state.dart';

class TimePicker extends StatefulWidget {
  const TimePicker(this.heading, this.initialTimeOfDay, {super.key});
  static const Color selectedButtonColor = Colors.green;
  final String heading;
  final LocalTime initialTimeOfDay;

  @override
  State<StatefulWidget> createState() => TimePickerState();

  static Future<LocalTimeState?> show(
      BuildContext context, String heading, LocalTime timeOfDay) {
    final result = showModalBottomSheet<LocalTimeState>(
        isScrollControlled: true,
        context: context,
        builder: (context) => TimePicker(heading, timeOfDay));

    return result;
  }
}

class TimePickerState extends State<TimePicker> {
  TimePickerState() {
    timeOfDay = LocalTimeState(widget.initialTimeOfDay);
  }
  late final LocalTimeState timeOfDay;

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<LocalTimeState>(
                create: (context) => timeOfDay),
            Provider<MoonPhase>(create: (context) => const MoonPhase())
          ],
          child: SizedBox(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            DialogHeading(widget.heading), // , style: widget.headingStyle),
            buildTimeEditor(),
            buildHourSelection(),
            buildMinuteSelection(),
            buidAMPMSelection(),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Padding(
                padding: const EdgeInsets.all(NJTheme.padding),
                child: NJButtonSecondary(
                  onPressed: () {
                    SQRouter().pop<void>();
                  },
                  label: 'CANCEL',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: NJTheme.padding),
                child: NJButtonPrimary(
                  onPressed: () {
                    SQRouter().pop(timeOfDay);
                  },
                  label: 'OK',
                ),
              ),
            ])
          ])));

  /// TIME/PHASE
  Widget buildTimeEditor() => Row(children: [
        Consumer<LocalTimeState>(
            builder: (context, timeOfDay, _) => NJTextSubheading(
                  'Time: ${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}${timeOfDay.isAM() ? ' am' : ' pm'}',
                )),
        //     TextFormField(),
        //    TextFormField(),
        Consumer<MoonPhase>(builder: (context, phase, _) => const MoonPhase())
      ]);

  Widget buildHourSelection() => Column(children: [
        const Align(
            alignment: Alignment.topLeft, child: NJTextNotice('Select Hour')),
        Row(children: [
          HourButton(label: '12'),
          HourButton(label: '1'),
          HourButton(label: '2'),
          HourButton(label: '3'),
          HourButton(label: '4'),
          HourButton(label: '5')
        ]),
        Row(children: [
          HourButton(label: '6'),
          HourButton(label: '7'),
          HourButton(label: '8'),
          HourButton(label: '9'),
          HourButton(label: '10'),
          HourButton(label: '11')
        ])
      ]);

  Widget buildMinuteSelection() => Column(children: [
        const Align(
            alignment: Alignment.topLeft, child: NJTextNotice('Select Minute')),
        Row(children: [
          MinuteButton(label: '00'),
          MinuteButton(label: '05'),
          MinuteButton(label: '10'),
          MinuteButton(label: '15'),
          MinuteButton(label: '20'),
          MinuteButton(label: '25')
        ]),
        Row(children: [
          MinuteButton(label: '30'),
          MinuteButton(label: '35'),
          MinuteButton(label: '40'),
          MinuteButton(label: '45'),
          MinuteButton(label: '50'),
          MinuteButton(label: '55')
        ])
      ]);

  Widget buidAMPMSelection() => Column(children: [
        const Align(
            alignment: Alignment.topLeft, child: NJTextNotice('Select AM/PM')),
        Row(children: [
          AMPMButton(label: 'AM'),
          AMPMButton(label: 'PM'),
        ]),
      ]);

  void oneTap() {}
}
