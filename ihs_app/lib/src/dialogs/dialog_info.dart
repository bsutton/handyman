import 'dart:core' as prefix0;
import 'dart:core';

import 'package:flutter/material.dart';

import '../widgets/dialog_heading.dart';
import '../widgets/theme/nj_button.dart';
import '../widgets/theme/nj_text_themes.dart';
import '../widgets/theme/nj_theme.dart';
import '../widgets/thumb_menu/thumb_menu.dart';

class DialogInfo extends StatefulWidget {
  const DialogInfo(
      {required this.context,
      required this.title,
      required this.message,
      super.key,
      this.titleColor});
  final String title;
  final Widget message;
  final Color? titleColor;
  final BuildContext context;

  @override
  State<StatefulWidget> createState() => DialogInfoState();

  static Future<void> show<T>(
      BuildContext context, String title, String message,
      {Color titleColor = NJColors.infoBackground}) async {
    await showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (context) => DialogInfo(
            context: context,
            title: title,
            message: NJTextSubheading(message),
            titleColor: titleColor));
  }

  static Future<void> showWithWidget(
      BuildContext context, String title, Widget message,
      {Color titleColor = NJColors.infoBackground}) async {
    await showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (context) => DialogInfo(
            context: context,
            title: title,
            message: message,
            titleColor: titleColor));
  }
}

class DialogInfoState extends State<DialogInfo> {
  DialogInfoState() {
    navigatorState = Navigator.of(context);
  }
  // We need our own copy of the nav state as the dialog
  // can get used directly from the scaffold in which case
  // scaffolds navigator used by SQRouter won't be available.
  late final NavigatorState navigatorState;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: NJColors.defaultBackground,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [buildHeading(), buildMessage(), buildButton()]),
      );

  Widget buildButton() => Padding(
      padding: const EdgeInsets.only(
          bottom: ThumbMenu.bottomInset, right: NJTheme.padding),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        NJButtonPrimary(
          label: 'OK',
          onPressed: () {
            navigatorState.pop();
          },
        ),
      ]));

  Widget buildHeading() => DialogHeading(
        widget.title,
        backgroundColor: widget.titleColor,
        textColor: NJColors.errorText,
      );

  Widget buildMessage() => Padding(
        padding: const EdgeInsets.all(8),
        child: widget.message,
      );
}
