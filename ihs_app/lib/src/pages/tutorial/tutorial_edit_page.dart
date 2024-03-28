import 'dart:async';

import 'package:completer_ex/completer_ex.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:webview_flutter/webview_flutter.dart';

import '../../app/app_scaffold.dart';
import '../../app/square_phone_app.dart';
import '../../dao/entities/tutorial.dart';
import '../../dao/repository/actions/action_tutorial_was_viewed.dart';
import '../../dao/repository/user_repository.dart';
import '../../dao/transaction/transaction_factory.dart';
import '../../widgets/alignment.dart';
import '../../widgets/empty.dart';
import '../../widgets/theme/nj_text_themes.dart';
import '../../widgets/theme/nj_theme.dart';

class TutorialEditPage extends StatefulWidget {
  const TutorialEditPage({required this.tutorial, super.key});
  final Tutorial tutorial;

  @override
  TutorialEditPageState createState() => TutorialEditPageState();
}

class TutorialEditPageState extends State<TutorialEditPage> {
  final CompleterEx<WebViewController> _controller =
      CompleterEx<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadData() async {
    final tutorial = widget.tutorial;
    await UserRepository().loggedInUser;
    await TransactionFactory.getActiveTransaction()
        .addAction(TutorialWasViewedAction(tutorial));
  }

  bool loaded = false;
  @override
  Widget build(BuildContext context) => AppScaffold(
      builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [buildSummary(), buildBody()]));

  Widget buildSubject() => Padding(
        padding: const EdgeInsets.only(bottom: NJTheme.padding),
        child: Surface(
            elevation: SurfaceElevation.e16,
            child: Left(
                child: NJTextHeadline(replace(widget.tutorial.subject ?? '')))),
      );

  Widget buildSummary() => Surface(
      elevation: SurfaceElevation.e12,
      child: NJTextSubheading(replace(widget.tutorial.summary ?? '')));

  Widget buildBody() =>
      // WebView(
      //     onPageFinished: (_) => onFinished(),
      //     initialUrl: buildUri(widget.tutorial.htmlBody!),
      //     onWebViewCreated: onWebCreated)));
      Expanded(
          child: Surface(
              child: Builder(
                  builder: (context) => SizedBox(
                      width: 1,
                      child: Visibility(
                          visible: loaded,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: const Empty())))));

  void onWebCreated(WebViewController webController) {
    _controller.complete(webController);
  }

  String buildUri(String htmlBody) {
    final html = '''
<html>
    <style type='text/css'>
        body { 
          color: white  !important;
          background: ${toHex(Surface.color(SurfaceElevation.e4))} !important; } 
    </style>
    <body>
    ${replace(widget.tutorial.htmlBody!)}
  </body>
</html>''';

    return Uri.dataFromString(html, mimeType: 'text/html').toString();
  }

  String toHex(Color color, {bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${color.red.toRadixString(16)}'
      '${color.green.toRadixString(16)}'
      '${color.blue.toRadixString(16)}';

  String replace(String htmlBody) =>
      htmlBody.replaceAll('%app_name%', SquarePhoneApp.name);

  void onFinished() {
    // we need to delay the displaying of the webview until after it has
    // a chance to finish rendering the page (or at least the background)
    // otherwise we get a white flash from the default browser background
    Future.delayed(
        const Duration(milliseconds: 200), () => setState(() => loaded = true));
  }
}
