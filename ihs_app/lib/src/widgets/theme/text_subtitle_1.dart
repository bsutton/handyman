import 'package:flutter/material.dart';

class TextSubtitle1 extends StatelessWidget {
  final String text;

  TextSubtitle1(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.subtitle1);
  }
}
