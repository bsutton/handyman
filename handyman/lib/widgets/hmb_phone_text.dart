import 'package:flutter/material.dart';
import 'package:strings/strings.dart';

import 'dial_widget.dart';

/// Displays the label and phoneNum.
/// If the phoneNum is null then we display nothing.
class HMBPhoneText extends StatelessWidget {
  const HMBPhoneText({required this.label, required this.phoneNo, super.key});
  final String label;
  final String? phoneNo;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (Strings.isNotBlank(phoneNo)) Text('$label $phoneNo'),
          if (Strings.isNotBlank(phoneNo)) DialWidget(phoneNo!)
        ],
      );
}
