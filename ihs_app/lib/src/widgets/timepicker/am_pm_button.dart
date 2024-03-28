import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'time_of_day_state.dart';
import 'time_picker.dart';

/// AMPM

class AMPMButton extends StatelessWidget {

  AMPMButton({required this.label, super.key}) : am = label.toLowerCase() == 'am';
  final String label;
  final bool am;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Consumer<LocalTimeState>(builder: (context, selected, _) {
      if (selected.isAM() && am || selected.isPM() && !am) {
        return ElevatedButton(
            onPressed: () => onPressed(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: TimePicker.selectedButtonColor),
            child: Text(label));
      } else {
        return ElevatedButton(
            onPressed: () => onPressed(context), child: Text(label));
      }
    }));

  VoidCallback? onPressed(BuildContext context) {
    final timeOfDay = Provider.of<LocalTimeState>(context, listen: false);

    timeOfDay.setAMPM(am: am);
    return null;
  }
}
