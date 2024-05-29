import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LocalContext extends StatefulWidget {
  const LocalContext({required this.builder, super.key});
  final Widget Function(BuildContext context) builder;

  @override
  LocalContextState createState() => LocalContextState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        ObjectFlagProperty<Widget Function(BuildContext context)>.has(
            'builder', builder));
  }
}

class LocalContextState extends State<LocalContext> {
  @override
  Widget build(BuildContext context) => widget.builder(context);
}
