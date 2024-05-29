import 'dart:io';

import 'package:direct_caller_sim_choice/direct_caller_sim_choice.dart';
import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:strings/strings.dart';

class DialWidget extends StatelessWidget {
  const DialWidget(this.phoneNo, {super.key});
  final String phoneNo;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.phone),
        onPressed: () async =>
            Strings.isEmpty(phoneNo) ? null : _call(context, phoneNo),
        color: Strings.isEmpty(phoneNo) ? Colors.grey : Colors.blue,
      );

  void _call(BuildContext context, String phoneNo) {
    final directCaller = DirectCaller();
    if (!Platform.isAndroid) {
      FToast.toast(context,
          toast: const Text('Dialing is only available on Android'));
    } else {
      directCaller.makePhoneCall(phoneNo);
    }
  }
}
