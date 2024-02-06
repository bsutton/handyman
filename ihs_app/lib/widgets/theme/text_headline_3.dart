import 'package:flutter/material.dart';

class TextHeadline3 extends StatelessWidget {
  final String text;

  TextHeadline3(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headline3);
  }
}
