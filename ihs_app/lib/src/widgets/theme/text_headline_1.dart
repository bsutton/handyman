import 'package:flutter/material.dart';

class TextHeadline1 extends StatelessWidget {

  const TextHeadline1(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: Theme.of(context).textTheme.displayLarge);
}
