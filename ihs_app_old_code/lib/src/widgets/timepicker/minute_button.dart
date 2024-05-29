import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'time_of_day_state.dart';
import 'time_picker.dart';

/// MINUTE
class MinuteButton extends StatelessWidget {
  MinuteButton({required this.label, super.key}) // , required this.onPressed})
      : setMinute = int.parse(label);
  // final VoidCallback onPressed;

  final String label;
  final int setMinute;

  @override
  Widget build(BuildContext context) =>
      Expanded(child: Consumer<LocalTimeState>(builder: (context, selected, _) {
        if (setMinute == selected.minute) {
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
    Provider.of<LocalTimeState>(context, listen: false).updateMinute(setMinute);

    return null;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(IntProperty('setMinute', setMinute));
  }
}
