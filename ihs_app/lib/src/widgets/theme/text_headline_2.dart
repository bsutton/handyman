import 'package:flutter/material.dart';

class TextHeadline2 extends StatelessWidget {

  const TextHeadline2(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: Theme.of(context).textTheme.displayMedium);
}
