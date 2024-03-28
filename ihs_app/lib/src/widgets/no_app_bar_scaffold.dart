import 'package:flutter/cupertino.dart';

import '../app/app_scaffold.dart';

///
/// Use [NoAppBarScaffold] to display a full screen page that
/// that doesn't want to display the App Bar nor FAB button.
class NoAppBarScaffold extends StatelessWidget {
  const NoAppBarScaffold({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => AppScaffold(
        appBar: const SizedBox.shrink(),
        builder: (context) => child,
      );
}
