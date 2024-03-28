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
}
