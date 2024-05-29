import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

import '../widgets/blocking_ui.dart';
import '../widgets/context_help/context_help_controller.dart';
import '../widgets/empty.dart';
import '../widgets/local_context.dart';
import '../widgets/position.dart';
import 'router.dart';

const double _kOfflineIndicatorHeight = 24;

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    required this.builder,
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.showHomeButton = false,
  });
  static const RouteName routeName = RouteName('AppScaffold');
  // TODO(bsutton): remove fixed height values here, should never be necessary
  static const double bottomBarHeight = 50;
  // The area above the bottom bar that widgets such
  // as the Home button and the `todo` widget expand into.
  static const double bottomBarExtension = 35;

  final WidgetBuilder builder;
  final Widget? appBar;
  final bool showHomeButton;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  State<StatefulWidget> createState() => AppScaffoldState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<WidgetBuilder>.has('builder', builder))
      ..add(DiagnosticsProperty<bool>('showHomeButton', showHomeButton))
      ..add(DiagnosticsProperty<FloatingActionButtonLocation?>(
          'floatingActionButtonLocation', floatingActionButtonLocation));
  }
}

class AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: _buildOverlays(),
      );

  Widget _buildOverlays() {
    final entries = <OverlayEntry>[
      OverlayEntry(builder: (_) => _buildScaffold()),
      OverlayEntry(
          builder: (_) => BlockingUIWidget(
                hideHelpIcon: widget.showHomeButton,
                placement: widget.showHomeButton
                    ? TopOrTailPlacement.bottom
                    : TopOrTailPlacement.top,
              ))
    ]

        // entries.add(OverlayEntry(builder: (_) => buildNoticeChip()));
        // entries.add(OverlayEntry(builder: (_) => buildTodoChip()));
        // entries.add(OverlayEntry(builder: (_) => buildErrorIndicator()));

        ;

    return Material(child: Overlay(initialEntries: entries));
  }

  Widget _buildScaffold() => ContextHelpController(
        child: Scaffold(
          // extendBody: true, // `TODO`: This is needed for scrolling bodies behind the bottomAppBar, but has flow-on effects for the rest of the layouts
          body: LocalContext(builder: _buildBody),
          bottomNavigationBar: LocalContext(
              builder: (context) => _buildAppBar(context) ?? const Empty()),
          floatingActionButton: _buildHomeButton(context),
          floatingActionButtonLocation: homeButtonLocation,
        ),
      );

  FloatingActionButtonLocation get homeButtonLocation =>
      FloatingActionButtonLocation.centerDocked;
  //widget.showHomeButton ? FloatingActionButtonLocation.centerDocked : null;

  Widget _buildBody(BuildContext context) => OfflineBuilder(
        child: widget.builder(context),
        connectivityBuilder: (context, connectivity, child) {
          final isConnected = connectivity != ConnectivityResult.none;
          final children = <Widget>[];
          if (!isConnected) {
            children.add(_buildOfflineIndicator(context));
          }
          children..add(Padding(
            padding: EdgeInsets.only(
                top: isConnected ? 0 : _kOfflineIndicatorHeight),
            child: child,
          ))
          ..add(_buildFAB(context));
          return Stack(
            fit: StackFit.expand,
            children: children,
          );
        },
      );

  Widget _buildFAB(BuildContext context) {
    switch (widget.floatingActionButtonLocation) {
      case FloatingActionButtonLocation.endFloat:
        return Positioned(
          bottom: kFloatingActionButtonMargin,
          right: kFloatingActionButtonMargin,
          child: widget.floatingActionButton!,
        );
      default:
        return Positioned(
          bottom: kFloatingActionButtonMargin,
          right: kFloatingActionButtonMargin,
          child: widget.floatingActionButton!,
        );
    }
  }

  Widget _buildOfflineIndicator(BuildContext context) => const Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: _kOfflineIndicatorHeight,
        child: ColoredBox(
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('OFFLINE'),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildHomeButton(BuildContext context) {
    if (!widget.showHomeButton) {
      return const Empty();
    }
    return FloatingActionButton(
      heroTag: 'HomeFAB',
      onPressed: () async => SQRouter().home(),
      tooltip: 'Home',
      child: const Icon(Icons.home),
    );
  }

  Widget? _buildAppBar(BuildContext context) => widget.appBar;
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FloatingActionButtonLocation>(
        'homeButtonLocation', homeButtonLocation));
  }
}
