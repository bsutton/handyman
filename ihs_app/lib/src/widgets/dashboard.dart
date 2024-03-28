import 'package:flutter/material.dart';

import '../app/app_scaffold.dart';
import 'theme/nj_theme.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({required this.heading, required this.rows, super.key});
  static double? height;

  final List<Row> rows;
  final Widget heading;

  @override
  State<StatefulWidget> createState() => DashboardState();

  static double getDashletHeight(BuildContext parentContext) {
    height ??= MediaQuery.of(parentContext).size.height / 3;

    return height!;
  }
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) => ColoredBox(
      color: Colors.black,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // heading
            Surface(
                child: FractionallySizedBox(
              widthFactor: 1,
              child: widget.heading,
            )),
            // Rows of the dashboard.
            Padding(
                padding: const EdgeInsets.only(
                    top: NJTheme.padding,
                    bottom: AppScaffold.bottomBarExtension),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: widget.rows,
                ))
          ]));
}
