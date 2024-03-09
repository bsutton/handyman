import 'package:flutter/material.dart';

class TextHeadline5 extends StatelessWidget {
  final String text;

  TextHeadline5(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.headline5);
  }
}
