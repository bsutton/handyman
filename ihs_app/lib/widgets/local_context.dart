import 'package:flutter/material.dart';

class LocalContext extends StatefulWidget {
  final Widget Function(BuildContext context) builder;

  LocalContext({Key key, @required this.builder}) : super(key: key);

  @override
  LocalContextState createState() => LocalContextState();
}

class LocalContextState extends State<LocalContext> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
