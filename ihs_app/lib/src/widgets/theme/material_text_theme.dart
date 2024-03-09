// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';

///
/// Exposes the set of material text theme names using the 2018 naming conventions.
class MaterialTextTheme {
  static TextStyle headline1(BuildContext context) => Theme.of(context).textTheme.headline1;
  static TextStyle headline2(BuildContext context) => Theme.of(context).textTheme.headline2;
  static TextStyle headline3(BuildContext context) => Theme.of(context).textTheme.headline3;
  static TextStyle headline4(BuildContext context) => Theme.of(context).textTheme.headline4;
  static TextStyle headline5(BuildContext context) => Theme.of(context).textTheme.headline5;
  static TextStyle headline6(BuildContext context) => Theme.of(context).textTheme.headline6;
  static TextStyle subtitle1(BuildContext context) => Theme.of(context).textTheme.subtitle1;
  static TextStyle bodyText2(BuildContext context) => Theme.of(context).textTheme.bodyText2;
  static TextStyle bodyText1(BuildContext context) => Theme.of(context).textTheme.bodyText1;
  static TextStyle caption(BuildContext context) => Theme.of(context).textTheme.caption;
  static TextStyle button(BuildContext context) => Theme.of(context).textTheme.button;
  static TextStyle subtitle2(BuildContext context) => Theme.of(context).textTheme.subtitle2;
  static TextStyle overline(BuildContext context) => Theme.of(context).textTheme.overline;
}
