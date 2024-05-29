import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TextHeadline5 extends StatelessWidget {
  const TextHeadline5(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.headlineSmall);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
  }
}
