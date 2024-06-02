import 'package:flutter/material.dart';
import 'package:strings/strings.dart';

import 'dial_widget.dart';

class PhoneText extends StatelessWidget {
  const PhoneText({required this.label, required this.phoneNo, super.key});
  final String label;
  final String phoneNo;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text('$label $phoneNo'),
          if (Strings.isNotBlank(phoneNo)) DialWidget(phoneNo)
        ],
      );
}
