import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'time_of_day_state.dart';
import 'time_picker.dart';

/// HOUR
class HourButton extends StatelessWidget {

  HourButton({required this.label, super.key}) : setHour = int.parse(label);
  final String label;
  final int setHour;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
            child: Consumer<LocalTimeState>(builder: (context, timeOfDay, _) {
              final hour = timeOfDay.hour;

              // The 12 hour button is used for midnight and midday (0 and 12)
              if (hour == setHour || (hour == 0 && setHour == 12)) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: TimePicker.selectedButtonColor,
                      disabledForegroundColor: Colors.grey.withOpacity(0.38),
                      disabledBackgroundColor: Colors.grey.withOpacity(0.12),
                      padding: EdgeInsets.zero),
                  onPressed: () => onPressed(context),
                  child: Text(label),
                );
              } else {
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding:  EdgeInsets.zero),
                    onPressed: () => onPressed(context),
                    child: Text(label));
              }
            })));

  VoidCallback? onPressed(BuildContext context) {
    final timeOfDay = Provider.of<LocalTimeState>(context, listen: false);

    timeOfDay.updateHour(setHour);
    return null;
  }
}
