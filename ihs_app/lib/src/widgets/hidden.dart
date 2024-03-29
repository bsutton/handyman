import 'package:flutter/material.dart';

class Hidden extends StatelessWidget {

  const Hidden({required this.child, required this.hidden, super.key});
  final bool hidden;
  final Widget child;

  @override
  Widget build(BuildContext context) => Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: !hidden,
      child: child,
    );
}
