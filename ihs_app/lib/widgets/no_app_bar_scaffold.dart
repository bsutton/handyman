import 'package:flutter/cupertino.dart';
import '../app/app_scaffold.dart';

///
/// Use [NoAppBarScaffold] to display a full screen page that
/// that doesn't want to display the App Bar nor FAB button.
class NoAppBarScaffold extends StatelessWidget {
  final Widget child;
  NoAppBarScaffold({@required this.child});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: Container(
        height: 0,
        width: 0,
      ),
      showHomeButton: false,
      builder: (context) => child,
    );
  }
}
