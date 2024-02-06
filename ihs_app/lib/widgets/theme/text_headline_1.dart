import 'package:flutter/material.dart';

class TextHeadline1 extends StatelessWidget {
  final String text;

  TextHeadline1(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headline1);
  }
}
