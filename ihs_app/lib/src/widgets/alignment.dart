import 'package:flutter/material.dart';

class Left extends StatelessWidget {

  const Left({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(alignment: Alignment.centerLeft, child: child);
}

class Right extends StatelessWidget {

  const Right({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(alignment: Alignment.centerRight, child: child);
}
