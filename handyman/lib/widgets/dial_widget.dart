import 'dart:io';

import 'package:direct_caller_sim_choice/direct_caller_sim_choice.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:strings/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import 'hmb_toast.dart';

class DialWidget extends StatelessWidget {
  const DialWidget(this.phoneNo, {super.key});
  final String phoneNo;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.phone),
        onPressed: () async =>
            Strings.isEmpty(phoneNo) ? null : _showOptions(context, phoneNo),
        color: Strings.isEmpty(phoneNo) ? Colors.grey : Colors.blue,
        tooltip: 'Call or Text',
      );

  Future<void> _showOptions(BuildContext context, String phoneNo) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Options'),
        content:
            const Text('Would you like to make a call or send a text message?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Call'),
            onPressed: () {
              Navigator.of(context).pop();
              _call(context, phoneNo);
            },
          ),
          TextButton(
            child: const Text('Text'),
            onPressed: () async {
              Navigator.of(context).pop();
              await _sendText(context, phoneNo);
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _call(BuildContext context, String phoneNo) async {
    if (!Platform.isAndroid) {
      HMBToast.notice(context, 'Dialing is only available on Android');
      return;
    }

    final status = await Permission.phone.status;
    if (status.isDenied) {
      final result = await Permission.phone.request();
      if (result.isDenied) {
        if (context.mounted) {
          HMBToast.notice(
              context, 'Phone permission is required to make calls');
        }
        return;
      }
    }

    DirectCaller().makePhoneCall(phoneNo);
  }

  Future<void> _sendText(BuildContext context, String phoneNo) async {
    final smsUri = Uri(
      scheme: 'sms',
      path: phoneNo,
    );

    final status = await Permission.sms.status;
    if (status.isDenied) {
      final result = await Permission.sms.request();
      if (result.isDenied) {
        if (context.mounted) {
          HMBToast.notice(context, 'SMS permission is required to make calls');
        }
        return;
      }
    }

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      if (context.mounted) {
        HMBToast.notice(context, 'Could not launch SMS application');
      }
    }
  }
}
