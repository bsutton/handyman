import 'package:flutter/material.dart';

class TextHeadline6 extends StatelessWidget {

  const TextHeadline6(this.text, {super.key, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleLarge?.copyWith(color: color);
    return Text(text, style: style);
  }
}
