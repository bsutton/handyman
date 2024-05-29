import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacktrace_impl/stacktrace_impl.dart';

import '../../app/router.dart';
import '../../widgets/blocking_ui.dart';
import '../../widgets/theme/nj_text_themes.dart';
import '../../widgets/theme/nj_theme.dart';
import '../../widgets/thumb_menu/custom_thumb_menu.dart';

///
/// Provide the [loadData]  method if your page needs to load any
/// async data.
/// The UI will display the BlockingUIWidget whilst you
/// load your data.
class DashboardPage<M extends CustomThumbMenu> extends StatefulWidget {
  const DashboardPage({
    required this.currentRouteName,
    required this.title,
    required this.builder,
    super.key,
    this.loadData,
    this.backgroundColor = NJColors.defaultBackground,
    this.thumbMenu,
  });
  final String title;
  final WidgetBuilder builder;
  final M? thumbMenu;
  final RouteName currentRouteName;
  final Color backgroundColor;
  final Future<void> Function(BuildContext)? loadData;

  @override
  State<StatefulWidget> createState() => DashboardPageState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(ObjectFlagProperty<WidgetBuilder>.has('builder', builder))
      ..add(DiagnosticsProperty<M?>('thumbMenu', thumbMenu))
      ..add(
          DiagnosticsProperty<RouteName>('currentRouteName', currentRouteName))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(ObjectFlagProperty<Future<void> Function(BuildContext p1)?>.has(
          'loadData', loadData));
  }
}

class DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) => BlockingUIBuilder<void>(
        future: () async => widget.loadData!(context),
        builder: (context, _) => ColoredBox(
          color: widget.backgroundColor,
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: NJTheme.bottomThumbMenuPadding),
            child: Column(children: [buildTitle(), buildBody()]),
          ),
        ),
        stacktrace: StackTraceImpl(),
      );

  Widget buildBody() => Expanded(
      child: Padding(
          padding: const EdgeInsets.all(NJTheme.padding),
          child: widget.builder(context)));

  Widget buildTitle() => FractionallySizedBox(
      widthFactor: 1,
      child: Surface(
          child: Container(
              height: 40,
              color: NJColors.appBarColor,
              child: Center(
                  child: NJTextPageHeading(widget.title,
                      color: NJColors.textHeading)))));
}
