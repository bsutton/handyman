import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'time_of_day_state.dart';
import 'time_picker.dart';

/// HOUR
class HourButton extends StatelessWidget {
  final String label;
  final int setHour;

  HourButton({@required this.label}) : setHour = int.parse(label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
            child: Consumer<LocalTimeState>(builder: (context, timeOfDay, _) {
              var hour = timeOfDay.hour;

              // The 12 hour button is used for midnight and midday (0 and 12)
              if (hour == setHour || (hour == 0 && setHour == 12)) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: TimePicker.selectedButtonColor,
                      onSurface: Colors.grey,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                  onPressed: () => onPressed(context),
                  child: Text(label),
                );
              } else {
                return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                    onPressed: () => onPressed(context),
                    child: Text(label));
              }
            })));
  }

  VoidCallback onPressed(BuildContext context) {
    var timeOfDay = Provider.of<LocalTimeState>(context, listen: false);

    timeOfDay.updateHour(setHour);
    return null;
  }
}
