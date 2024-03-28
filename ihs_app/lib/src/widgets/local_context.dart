import 'package:flutter/material.dart';

class LocalContext extends StatefulWidget {

  const LocalContext({required this.builder, super.key});
  final Widget Function(BuildContext context) builder;

  @override
  LocalContextState createState() => LocalContextState();
}

class LocalContextState extends State<LocalContext> {
  @override
  Widget build(BuildContext context) => widget.builder(context);
}
