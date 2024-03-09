import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'time_of_day_state.dart';
import 'time_picker.dart';

/// MINUTE
class MinuteButton extends StatelessWidget {
  // final VoidCallback onPressed;

  final String label;
  final int setMinute;

  MinuteButton({@required this.label}) // , @required this.onPressed})
      : setMinute = int.parse(label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Consumer<LocalTimeState>(builder: (context, selected, _) {
      if (setMinute == selected.minute) {
        return ElevatedButton(
            onPressed: () => onPressed(context),
            child: Text(label),
            style: ElevatedButton.styleFrom(
                primary: TimePicker.selectedButtonColor));
      } else {
        return ElevatedButton(
            onPressed: () => onPressed(context), child: Text(label));
      }
    }));
  }

  VoidCallback onPressed(BuildContext context) {
    var timeOfDay = Provider.of<LocalTimeState>(context, listen: false);

    timeOfDay.updateMinute(setMinute);

    return null;
  }
}
