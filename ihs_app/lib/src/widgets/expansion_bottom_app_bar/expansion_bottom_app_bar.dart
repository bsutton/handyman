import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const Duration _kExpand = Duration(milliseconds: 200);
const double _minFlingVelocity = 700;
const double _gestureProgressThreshold = 0.5;

class _InheritedExpansionBottomAppBar extends InheritedWidget {
  const _InheritedExpansionBottomAppBar(
      {required this.state, required super.child, super.key});

  final ExpansionBottomAppBarState state;

  @override
  bool updateShouldNotify(_InheritedExpansionBottomAppBar oldWidget) => true;
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<ExpansionBottomAppBarState>('state', state));
  }
}

class ExpansionBottomAppBar extends StatefulWidget {
  const ExpansionBottomAppBar(
      {required this.bottomAppBar, required this.menu, super.key});

  final Widget bottomAppBar;
  final Widget menu;

  static ExpansionBottomAppBarState of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedExpansionBottomAppBar>()!
      .state;

  @override
  ExpansionBottomAppBarState createState() => ExpansionBottomAppBarState();
}

class ExpansionBottomAppBarState extends State<ExpansionBottomAppBar>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  final GlobalKey _childKey =
      GlobalKey(debugLabel: 'Expansion Bottom App Bar child');

  late AnimationController _controller;
  late Animation<double> _heightFactor;

  bool _isExpanded = false;
  bool _toggleUnderway = false;

  double get _childHeight {
    final renderBox =
        _childKey.currentContext!.findRenderObject()! as RenderBox;
    return renderBox.size.height;
  }

  void open(VoidCallback fn) {
    setState(() {
      _toggleUnderway = true;
      _isExpanded = true;
      _controller.forward().then<void>((_) {
        fn();
        if (!mounted) {
          return;
        }
        setState(() {
          _toggleUnderway = false;
        });
      });
    });
  }

  void close(VoidCallback fn) {
    setState(() {
      _toggleUnderway = true;
      _isExpanded = false;
      _controller.reverse().then<void>((_) {
        fn();
        if (!mounted) {
          return;
        }
        setState(() {
          _toggleUnderway = false;
        });
      });
    });
  }

  void toggle() {
    setState(() {
      if (_isExpanded) {
        close(() {});
      } else {
        open(() {});
      }
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_toggleUnderway) {
      return;
    }
    _controller.value -= details.primaryDelta ?? 1 / _childHeight;
    // (_childHeight ?? details.primaryDelta ?? 0.0);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_toggleUnderway) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dy > _minFlingVelocity) {
      final flingVelocity = -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (_controller.value > 0.0) {
        _controller.fling(velocity: flingVelocity);
      }
      if (flingVelocity < 0.0) {
        setState(() {
          _isExpanded = false;
        });
      }
    } else if (_controller.value < _gestureProgressThreshold) {
      if (_controller.value > 0.0) {
        _controller.fling(velocity: -1);
      }
      setState(() {
        _isExpanded = false;
      });
    } else {
      _controller.forward();
      setState(() {
        _isExpanded = true;
      });
    }
  }

  Widget _buildChildren(BuildContext context, Widget? child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          widget.bottomAppBar,
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheritedExpansionBottomAppBar(
        state: this,
        child: GestureDetector(
          onVerticalDragUpdate: _handleDragUpdate,
          onVerticalDragEnd: _handleDragEnd,
          excludeFromSemantics: true,
          child: AnimatedBuilder(
            animation: _controller.view,
            builder: _buildChildren,
            /*
        child: Material(
          key: _childKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.children,
          ),
        ),
        */
            child: Container(
              key: _childKey,
              child: widget.menu,
            ),
          ),
        ),
      );
}
