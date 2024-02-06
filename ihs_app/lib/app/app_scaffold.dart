import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../widgets/blocking_ui.dart';
import '../widgets/context_help/context_help_controller.dart';
import '../widgets/j_bottom_app_bar/nj_bottom_app_bar.dart';
import '../widgets/local_context.dart';
import '../widgets/position.dart';
import 'router.dart';

const double _kOfflineIndicatorHeight = 24.0;

class AppScaffold extends StatefulWidget {
  static const RouteName routeName = RouteName('AppScaffold');
  // TODO: remove fixed height values here, should never be necessary
  static const double BOTTOM_BAR_HEIGHT = 50;
  // The area above the bottom bar that widgets such
  // as the Home button and the todo widget expand into.
  static const double BOTTOM_BAR_EXTENSION = 35;

  final WidgetBuilder builder;
  final Widget appBar;
  final bool showHomeButton;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;

  AppScaffold({
    Key key,
    this.builder,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    bool showHomeButton,
  })  : showHomeButton = showHomeButton ?? true,
        super(key: key);

  @override
  State<StatefulWidget> createState() => AppScaffoldState();
}

class AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _buildOverlays(),
    );
  }

  Widget _buildOverlays() {
    var entries = <OverlayEntry>[];

    entries.add(OverlayEntry(builder: (_) => _buildScaffold()));

    // entries.add(OverlayEntry(builder: (_) => buildNoticeChip()));
    // entries.add(OverlayEntry(builder: (_) => buildTodoChip()));
    // entries.add(OverlayEntry(builder: (_) => buildErrorIndicator()));

    entries.add(OverlayEntry(
        builder: (_) => BlockingUIWidget(
              hideHelpIcon: widget.showHomeButton,
              placement: widget.showHomeButton
                  ? TopOrTailPlacement.bottom
                  : TopOrTailPlacement.top,
            )));

    return Material(child: Overlay(initialEntries: entries));
  }

  Widget _buildScaffold() {
    return ContextHelpController(
      child: Scaffold(
        //extendBody: true, // TODO: This is needed for scrolling bodies behind the bottomAppBar, but has flow-on effects for the rest of the layouts
        body: LocalContext(builder: _buildBody),
        bottomNavigationBar: LocalContext(builder: _buildAppBar),
        floatingActionButton: _buildHomeButton(context),
        floatingActionButtonLocation: homeButtonLocation,
      ),
    );
  }

  FloatingActionButtonLocation get homeButtonLocation =>
      FloatingActionButtonLocation.centerDocked;
  //widget.showHomeButton ? FloatingActionButtonLocation.centerDocked : null;

  Widget _buildBody(BuildContext context) {
    return OfflineBuilder(
      child: widget.builder(context),
      connectivityBuilder: (context, connectivity, child) {
        final isConnected = connectivity != ConnectivityResult.none;
        final children = <Widget>[];
        if (!isConnected) {
          children.add(_buildOfflineIndicator(context));
        }
        children.add(Padding(
          padding:
              EdgeInsets.only(top: isConnected ? 0 : _kOfflineIndicatorHeight),
          child: child,
        ));
        if (widget.floatingActionButton != null) {
          children.add(_buildFAB(context));
        }
        return Stack(
          fit: StackFit.expand,
          children: children,
        );
      },
    );
  }

  Widget _buildFAB(BuildContext context) {
    switch (widget.floatingActionButtonLocation) {
      case FloatingActionButtonLocation.endFloat:
        return Positioned(
          bottom: kFloatingActionButtonMargin,
          right: kFloatingActionButtonMargin,
          child: widget.floatingActionButton,
        );
        break;
      default:
        return Positioned(
          bottom: kFloatingActionButtonMargin,
          right: kFloatingActionButtonMargin,
          child: widget.floatingActionButton,
        );
    }
  }

  Widget _buildOfflineIndicator(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: _kOfflineIndicatorHeight,
      child: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('OFFLINE'),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: SizedBox(
                width: 16.0,
                height: 16.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    if (!widget.showHomeButton) {
      return null;
    }
    return FloatingActionButton(
      heroTag: 'HomeFAB',
      onPressed: () => SQRouter().home(),
      tooltip: 'Home',
      child: Icon(Icons.home),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    if (widget.appBar != null) {
      return widget.appBar;
    }
    return NjBottomAppBar(
      shape: widget.showHomeButton ? CircularNotchedRectangle() : null,
    );
  }
}
