import 'package:flutter/material.dart';

class TextBody1 extends StatelessWidget {

  const TextBody1(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: Theme.of(context).textTheme.bodyLarge);
}
