import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app/router.dart';
import '../widgets/dialog_heading.dart';
import '../widgets/theme/nj_button.dart';
import '../widgets/theme/nj_text_themes.dart';
import '../widgets/theme/nj_theme.dart';
import '../widgets/thumb_menu/thumb_menu.dart';

enum DialogQuestionResult { yes, no }

class DialogQuestion extends StatefulWidget {
  const DialogQuestion._internal(
      {required this.context,
      required this.title,
      required this.question,
      this.titleColor,
      this.noLabel,
      this.yesLabel});
  final String title;
  final Widget question;
  final Color? titleColor;
  final BuildContext context;
  final String? noLabel;
  final String? yesLabel;

  ///
  /// Displays a modal dialog suitlable for asking a two option question (e.g. yes/no)
  ///
  /// [title] the title to display on the dialog.
  /// [question] A String containing the question.
  /// [titleColor] the color of the title
  /// [context] build context
  /// [noLabel] the label to show on the left hand button - defaults to 'No'
  ///   If the user clicks the [noLabel] [DialogQuestionResult.no] is returned.
  /// If the [noLabel] is null then the No button will not be displayed.
  /// [yesLabel] the lable to show on the right hand button - defaults to 'Yes'
  ///   If the user clicks the [yesLabel] [DialogQuestionResult.yes] is
  ///  returned.
  static Future<DialogQuestionResult?> show(
      BuildContext context, String title, String question,
      {Color titleColor = NJColors.infoBackground,
      String noLabel = 'No',
      String yesLabel = 'Yes'}) {
    final result = showModalBottomSheet<DialogQuestionResult>(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (context) => DialogQuestion._internal(
          context: context,
          title: title,
          question: NJTextSubheading(question),
          titleColor: titleColor,
          noLabel: noLabel,
          yesLabel: yesLabel),
    );

    return result;
  }

  ///
  /// Displays a modal dialog suitlable for asking a two option question (e.g. yes/no)
  ///
  /// [title] the title to display on the dialog.
  /// [question] A widget containing the question. Normally a Text object.
  /// [titleColor] the color of the title
  /// [context] build context
  /// [noLabel] the label to show on the left hand button.
  ///   If the user clicks the [noLabel] [DialogQuestionResult.no] is returned.
  /// [yesLabel] the lable to show on the right hand button.
  ///   If the user clicks the [yesLabel] [DialogQuestionResult.yes]
  /// is returned.
  static Future<DialogQuestionResult?> showWithWidget(
      BuildContext context, String title, Widget question,
      {Color titleColor = NJColors.infoBackground,
      String noLabel = 'No',
      String yesLabel = 'Yes'}) async {
    final result = showModalBottomSheet<DialogQuestionResult>(
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) => DialogQuestion._internal(
            context: context,
            title: title,
            question: question,
            titleColor: titleColor,
            noLabel: noLabel,
            yesLabel: yesLabel));

    return result;
  }

  @override
  State<StatefulWidget> createState() => DialogQuestionState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(StringProperty('title', title))
    ..add(ColorProperty('titleColor', titleColor))
    ..add(DiagnosticsProperty<BuildContext>('context', context))
    ..add(StringProperty('noLabel', noLabel))
    ..add(StringProperty('yesLabel', yesLabel));
  }
}

class DialogQuestionState extends State<DialogQuestion> {
  DialogQuestionState() {
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
          bottom: ThumbMenu.bottomInset,
          right: NJTheme.padding,
          left: NJTheme.padding),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        NJButtonSecondary(
            label: widget.noLabel ?? 'No',
            onPressed: () => SQRouter().pop(DialogQuestionResult.no)),
        NJButtonPrimary(
          label: widget.yesLabel ?? 'Yes',
          onPressed: () {
            SQRouter().pop(DialogQuestionResult.yes);
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
        child: widget.question,
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<NavigatorState>('navigatorState', navigatorState));
  }
}
