import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app/router.dart';
import '../widgets/dialog_heading.dart';
import '../widgets/theme/nj_button.dart';
import '../widgets/theme/nj_theme.dart';
import '../widgets/thumb_menu/thumb_menu.dart';

typedef Validator = bool Function();

class DialogFullScreen extends StatelessWidget {
  const DialogFullScreen(
      {required this.title,
      required this.builder,
      super.key,
      this.dialogKey,
      this.okLabel = 'OK',
      this.cancelLabel = 'CANCEL',
      this.onOK,
      this.onCancel,
      this.showCancel = true,
      this.validator});
  final Key? dialogKey;

  final WidgetBuilder builder;

  final String title;

  final String okLabel;
  final String cancelLabel;

  final VoidCallback? onOK;
  final VoidCallback? onCancel;

  final Validator? validator;

  final bool showCancel;

  static Future<void> show(BuildContext context,
      {required String title,
      required WidgetBuilder builder,
      String okLabel = 'OK',
      String cancelLabel = 'CANCEL',
      VoidCallback? onOK,
      VoidCallback? onCancel,
      Validator? validator,
      bool showCancel = true}) async {
    await showGeneralDialog<void>(
        context: context,
        barrierColor: Colors.black12.withOpacity(0.6),
        pageBuilder: (context, _, __) => Material(
              child: SafeArea(
                  child: DialogFullScreen(
                      title: title,
                      okLabel: okLabel,
                      cancelLabel: cancelLabel,
                      onOK: onOK,
                      validator: validator,
                      onCancel: onCancel,
                      showCancel: showCancel,
                      builder: (context) => Material(
                          // child:
                          // SingleChildScrollView(
                          child: builder(context)
                          //)
                          ))),
            ));
  }

  @override
  Widget build(BuildContext context) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DialogHeading(title),
            Expanded(child: builder(context)),
            buildOKCancel(context)
          ]);

  Widget buildOKCancel(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: ThumbMenu.bottomInset),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ...buildCancel(),
        Padding(
          padding: const EdgeInsets.only(right: NJTheme.padding),
          child: NJButtonPrimary(
            label: okLabel,
            onPressed: () {
              if (validator?.call() ?? true) {
                onOK?.call();
                SQRouter().pop<void>();
              }
            },
          ),
        ),
      ]));

  List<Widget> buildCancel() {
    final results = <Widget>[];

    if (showCancel) {
      results.add(Padding(
        padding: const EdgeInsets.only(right: NJTheme.padding),
        child: NJButtonSecondary(
            label: cancelLabel,
            onPressed: () {
              onCancel?.call();
              SQRouter().pop<void>();
            }),
      ));
    }

    return results;
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(ObjectFlagProperty<WidgetBuilder>.has('builder', builder))
    ..add(DiagnosticsProperty<Key?>('dialogKey', dialogKey))
    ..add(StringProperty('title', title))
    ..add(StringProperty('okLabel', okLabel))
    ..add(StringProperty('cancelLabel', cancelLabel))
    ..add(ObjectFlagProperty<VoidCallback?>.has('onOK', onOK))
    ..add(ObjectFlagProperty<VoidCallback?>.has('onCancel', onCancel))
    ..add(ObjectFlagProperty<Validator?>.has('validator', validator))
    ..add(DiagnosticsProperty<bool>('showCancel', showCancel));
  }
}
