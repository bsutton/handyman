import 'dart:io';

import 'package:direct_caller_sim_choice/direct_caller_sim_choice.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:strings/strings.dart';

import '../util/clip_board.dart';
import '../util/platform_ex.dart';
import 'hmb_toast.dart';

class DialWidget extends StatelessWidget {
  const DialWidget(this.phoneNo, {super.key});
  final String phoneNo;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
        mainAxisSize: MainAxisSize.min, // added line
        children: [
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.phone),
            onPressed: () async => Strings.isEmpty(phoneNo)
                ? null
                : _showOptions(context, phoneNo),
            color: Strings.isEmpty(phoneNo) ? Colors.grey : Colors.blue,
            tooltip: 'Call or Text',
          ),
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.copy),
            onPressed: () async => Strings.isEmpty(phoneNo)
                ? null
                : clipboardCopyTo(context, phoneNo),
            color: Strings.isEmpty(phoneNo) ? Colors.grey : Colors.blue,
            tooltip: 'Copy Phone No. to the Clipboard',
          ),
        ],
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
              await _showTextInputDialog(context, phoneNo);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
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

  Future<void> _sendText(
      BuildContext context, String phoneNo, String messageText) async {
    final status = await Permission.sms.status;
    if (status.isDenied) {
      final result = await Permission.sms.request();
      if (result.isDenied && context.mounted) {
        HMBToast.notice(context, 'SMS permission is required to send texts');
        return;
      }
    }

    try {
      final sender = SmsSender();

      final message = SmsMessage(phoneNo, messageText);
      message.onStateChanged.listen((state) {
        if (state == SmsMessageState.Sent) {
          // TODO(bsutton): this won't show as the context is
          // gone by the time the notice arrives.
          // consider show a dialog that remains open util
          // the sms is sent.
          HMBToast.notice(context, 'SMS sent successfully');
        } else if (state == SmsMessageState.Fail) {
          HMBToast.error(context, 'Failed to send SMS');
        }
      });
      await sender.sendSms(message);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      if (context.mounted) {
        HMBToast.error(context, 'Could not launch SMS application');
      }
    }
  }

  Future<void> _showTextInputDialog(
      BuildContext context, String phoneNo) async {
    final messageText = await showDialog<String>(
      context: context,
      builder: (context) {
        var text = '';
        return AlertDialog(
          title: const Text('Send Text Message'),
          content: TextField(
            autofocus: isNotMobile,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) {
              text = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter your message here',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send'),
              onPressed: () {
                Navigator.of(context).pop(text);
              },
            ),
          ],
        );
      },
    );

    if (messageText != null && messageText.isNotEmpty) {
      if (context.mounted) {
        await _sendText(context, phoneNo, messageText);
      }
    }
  }
}