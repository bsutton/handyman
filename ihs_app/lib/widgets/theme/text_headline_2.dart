import 'package:flutter/material.dart';

class TextHeadline2 extends StatelessWidget {
  final String text;

  TextHeadline2(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headline2);
  }
}
