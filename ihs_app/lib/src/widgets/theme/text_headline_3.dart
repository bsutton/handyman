import 'package:flutter/material.dart';

class TextHeadline3 extends StatelessWidget {

  const TextHeadline3(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: Theme.of(context).textTheme.displaySmall);
}
