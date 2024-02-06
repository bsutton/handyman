import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'time_of_day_state.dart';
import 'time_picker.dart';

/// AMPM

class AMPMButton extends StatelessWidget {
  final String label;
  final bool am;

  AMPMButton({@required this.label}) : am = label.toLowerCase() == 'am';

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Consumer<LocalTimeState>(builder: (context, selected, _) {
      if (selected.isAM() && am || selected.isPM() && !am) {
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

    timeOfDay.setAMPM(am: am);
    return null;
  }
}
