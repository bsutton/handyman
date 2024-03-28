// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';

///
/// Exposes the set of material text theme names using the 2018 naming conventions.
class MaterialTextTheme {
  static TextStyle headline1(BuildContext context) => Theme.of(context).textTheme.displayLarge!;
  static TextStyle headline2(BuildContext context) => Theme.of(context).textTheme.displayMedium!;
  static TextStyle headline3(BuildContext context) => Theme.of(context).textTheme.displaySmall!;
  static TextStyle headline4(BuildContext context) => Theme.of(context).textTheme.headlineMedium!;
  static TextStyle headline5(BuildContext context) => Theme.of(context).textTheme.headlineSmall!;
  static TextStyle headline6(BuildContext context) => Theme.of(context).textTheme.titleLarge!;
  static TextStyle subtitle1(BuildContext context) => Theme.of(context).textTheme.titleMedium!;
  static TextStyle bodyText2(BuildContext context) => Theme.of(context).textTheme.bodyMedium!;
  static TextStyle bodyText1(BuildContext context) => Theme.of(context).textTheme.bodyLarge!;
  static TextStyle caption(BuildContext context) => Theme.of(context).textTheme.bodySmall!;
  static TextStyle button(BuildContext context) => Theme.of(context).textTheme.labelLarge!;
  static TextStyle subtitle2(BuildContext context) => Theme.of(context).textTheme.titleSmall!;
  static TextStyle overline(BuildContext context) => Theme.of(context).textTheme.labelSmall!;
}
