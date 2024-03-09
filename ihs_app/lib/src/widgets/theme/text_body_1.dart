import 'package:flutter/material.dart';

class TextBody1 extends StatelessWidget {
  final String text;

  TextBody1(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.bodyText1);
  }
}
