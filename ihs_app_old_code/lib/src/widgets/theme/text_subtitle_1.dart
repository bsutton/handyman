import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TextSubtitle1 extends StatelessWidget {
  const TextSubtitle1(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.titleMedium);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
  }
}
