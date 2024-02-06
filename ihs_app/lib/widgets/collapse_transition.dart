import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CollapseTransition extends StatelessWidget {
  const CollapseTransition(
      {required this.child, required this.controller, super.key});
  final AnimationController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: controller,
        child: SizeTransition(
          sizeFactor: controller,
          child: child,
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<AnimationController>('controller', controller));
  }
}
