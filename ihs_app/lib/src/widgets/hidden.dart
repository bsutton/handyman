import 'package:flutter/material.dart';

class Hidden extends StatelessWidget {
  final bool hidden;
  final Widget child;

  Hidden({@required this.child, this.hidden});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: child,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: !hidden,
    );
  }
}
