import 'package:flutter/material.dart';

import 'context_help_controller.dart';

const _kScrollDuration = Duration(milliseconds: 200);

/// Determines the shape of the [ContextHelp] highlight.
enum ContextHelpShape {
  Circle,
  Rectangle,
}

/// Wrapping a [Widget] with this widget will register contextual help with the
/// nearest [ContextHelpController] ancestor.
class ContextHelp extends StatefulWidget {
  const ContextHelp({
    required this.child,
    required this.title,
    required this.body,
    super.key,
    this.shape = ContextHelpShape.Circle,
    this.highlight = true,
  });
  final Widget child;
  final Widget title;
  final Widget body;
  final ContextHelpShape shape;

  /// Set to false to disable highlighting of the [child] when this help topic is displayed.
  final bool highlight;

  @override
  ContextHelpState createState() => ContextHelpState();
 
}

class ContextHelpState extends State<ContextHelp> {
  late ContextHelpControllerState _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller = ContextHelpController.of(context);
      _controller.register(this);
    });
  }

  @override
  void didChangeDependencies() {
    final controller = ContextHelpController.of(context);
    if (controller != _controller) {
      _controller = controller;
      _controller.register(this);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.unregister(this);
    super.dispose();
  }

  Future<void> ensureVisible() =>
      Scrollable.ensureVisible(context, duration: _kScrollDuration);

  @override
  Widget build(BuildContext context) => widget.child;
}
