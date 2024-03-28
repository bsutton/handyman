import 'package:flutter/material.dart';

class CenterHorizontal extends StatelessWidget {
  const CenterHorizontal(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [child]);
}
