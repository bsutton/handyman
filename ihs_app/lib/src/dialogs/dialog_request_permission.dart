import 'package:flutter/material.dart';

import '../app/router.dart';
import '../widgets/thumb_menu/thumb_menu.dart';

class DialogRequestPermission extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  DialogRequestPermission(this.reason, {super.key})
      : headingStyle =
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        buttonHeaddings = const TextStyle(fontWeight: FontWeight.bold),
        timeLabel =
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue);
  final TextStyle headingStyle;
  final TextStyle buttonHeaddings;
  final TextStyle timeLabel;

  final String reason;

  @override
  State<StatefulWidget> createState() => DialogRequestPermissionState();

  static Future<bool> show(BuildContext context, String reason) async {
    final result = await showModalBottomSheet<bool>(
        isScrollControlled: true,
        context: context,
        builder: (context) => DialogRequestPermission(reason));

    return result ?? false;
  }
}

class DialogRequestPermissionState extends State<DialogRequestPermission> {
  @override
  Widget build(BuildContext context) =>
      Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Request Permissions', style: widget.headingStyle),
        const Divider(height: 20, color: Colors.black),
        Padding(padding: const EdgeInsets.all(20), child: Text(widget.reason)),
        const Divider(height: 20, color: Colors.black),
        Padding(
            padding: const EdgeInsets.only(bottom: ThumbMenu.bottomInset),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              SimpleDialogOption(
                onPressed: () {
                  SQRouter().pop(false);
                },
                child: const Text('CANCEL'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  SQRouter().pop(true);
                },
                child: const Text('OK'),
              ),
            ]))
      ]);
}
