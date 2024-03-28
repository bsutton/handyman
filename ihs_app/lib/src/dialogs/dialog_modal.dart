import 'dart:core';

import 'package:flutter/material.dart';

import '../app/router.dart';
import '../widgets/dialog_heading.dart';
import '../widgets/local_context.dart';
import '../widgets/theme/nj_button.dart';
import '../widgets/theme/nj_theme.dart';
import '../widgets/thumb_menu/thumb_menu.dart';

enum DialogResult { ok, cancel }

class DialogModal extends StatefulWidget {
  const DialogModal(
      {required this.title,
      required this.builder,
      super.key,
      this.dialogKey,
      this.okLabel = 'OK',
      this.cancelLabel = 'CANCEL',
      this.onOK,
      this.onCancel,
      this.showCancel = true});
  final Key? dialogKey;

  final WidgetBuilder builder;

  final String title;

  final String okLabel;
  final String cancelLabel;

  final VoidCallback? onOK;
  final VoidCallback? onCancel;

  final bool showCancel;

  @override
  State<StatefulWidget> createState() => DialogModalState();

  /// Shows a modal dialog.
  ///
  /// Add handlers for [onOK] and
  /// [onCancel] to get a callback when the dialog closes.
  ///
  /// Pass a value to [title] to set the title of the dialog.
  /// You can modify the button labels by passing [okLabel] and
  /// or [cancelLabel] which default to 'OK' and 'CANCEL' respectively.
  ///
  /// You can control whether the cancel button is displayed via [showCancel].
  /// The cancel button is show by default.
  static Future<void> show(BuildContext context,
      {required String title,
      required WidgetBuilder builder,
      String okLabel = 'OK',
      String cancelLabel = 'CANCEL',
      VoidCallback? onOK,
      VoidCallback? onCancel,
      bool showCancel = true}) async {
    await showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (context) => DialogModal(
            title: title,
            okLabel: okLabel,
            cancelLabel: cancelLabel,
            onOK: onOK,
            onCancel: onCancel,
            showCancel: showCancel,
            builder: builder));
  }
}

class DialogModalState extends State<DialogModal> {
  DialogModalState();
  Duration duration = Duration.zero;

  @override
  Widget build(BuildContext context) => Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            DialogHeading(widget.title),
            widget.builder(context),
            buildOKCancel()
          ]);

  Widget buildOKCancel() => LocalContext(
      builder: (_) => Padding(
          padding: const EdgeInsets.only(bottom: ThumbMenu.bottomInset),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            ...buildCancel(),
            Padding(
              padding: const EdgeInsets.only(right: NJTheme.padding),
              child: NJButtonPrimary(
                label: widget.okLabel,
                onPressed: () {
                  widget.onOK?.call();
                  SQRouter().pop<void>();
                },
              ),
            ),
          ])));

  List<Widget> buildCancel() {
    final results = <Widget>[];

    if (widget.showCancel) {
      results.add(Padding(
        padding: const EdgeInsets.only(right: NJTheme.padding),
        child: NJButtonSecondary(
            label: widget.cancelLabel,
            onPressed: () {
              widget.onCancel?.call();
              SQRouter().pop<void>();
            }),
      ));
    }

    return results;
  }
}
