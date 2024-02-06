import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'context_help_controller.dart';

/// This widget should be placed to invoke the nearest [ContextHelpController]
/// ancestor, and will display itself when the controller has active help
/// topics.
class ContextHelpButton extends StatefulWidget {
  const ContextHelpButton({required this.controllerKey, super.key});
  final GlobalKey<ContextHelpControllerState> controllerKey;

  @override
  ContextHelpButtonState createState() => ContextHelpButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<GlobalKey<ContextHelpControllerState>>(
        'controllerKey', controllerKey));
  }
}

class ContextHelpButtonState extends State<ContextHelpButton> {
  late ContextHelpControllerState? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller = widget.controllerKey.currentState;
      _controller?.addListener(_updateActive);
    });
  }

  @override
  void didChangeDependencies() {
    ContextHelpControllerState? controller;
    controller = widget.controllerKey.currentState;
    if (_controller != controller) {
      _controller = controller;
      _controller?.addListener(_updateActive);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller?.removeListener(_updateActive);
    super.dispose();
  }

  void _updateActive() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ContextHelpController.of(context);
    if (!controller.active) {
      return const SizedBox.shrink();
    }
    return IconButton(
      icon: const Icon(Icons.help_outline),
      onPressed: controller.show,
    );
  }
}
