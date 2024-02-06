import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'context_help.dart';

const double _kCutoutScaleFactor = 1.05;
const double _kControlsHeight = 48;
const double _kTextMargin = 12;
const Duration _kTransitionDuration = Duration(milliseconds: 150);
final Color _kCutoutBackgroundColor = Colors.black.withOpacity(0.87);

class _InheritedContextHelpController extends InheritedWidget {
  const _InheritedContextHelpController({
    required this.state,
    required super.child,
  });

  final ContextHelpControllerState state;

  @override
  bool updateShouldNotify(_InheritedContextHelpController old) => false;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<ContextHelpControllerState>('state', state));
  }
}

/// This controller is included in any page that is built using AppScaffold.
///
/// [ContextHelp] topics and ContextHelpButton in the subtree will register
/// against the closest controller, controllers may be nested if multiple sets
/// of help are required.
class ContextHelpController extends StatefulWidget {
  const ContextHelpController({required this.child, super.key});

  final Widget child;

  static ContextHelpControllerState of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedContextHelpController>()!
      .state;

  @override
  ContextHelpControllerState createState() => ContextHelpControllerState();
}

class ContextHelpControllerState extends State<ContextHelpController>
    with SingleTickerProviderStateMixin
    implements Listenable {
  final List<ContextHelpState> _steps = <ContextHelpState>[];
  final List<OverlayEntry> _overlayEntries = <OverlayEntry>[];
  final _ContextHelpNotifier _notifier = _ContextHelpNotifier();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _kTransitionDuration,
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  OverlayEntry _buildOverlayBackground(
          ContextHelpState step, _TargetDimensions targetDimensions) =>
      OverlayEntry(
          builder: (context) => SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, _) => CustomPaint(
                    painter: _ContextHelpCutoutPainter(
                        step, targetDimensions, _animation.value),
                  ),
                ),
              ));

  Widget _buildControls(ContextHelpState step) {
    final stepNo = _steps.indexOf(step);
    final lastStep = stepNo == _steps.length - 1;
    final controlsChildren = <Widget>[
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextButton(onPressed: hide, child: const Text('Skip')),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextButton(
            onPressed:
                stepNo > 0 ? () async => show(step: _steps[stepNo - 1]) : null,
            child: const Text('Back'),
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton(
            onPressed: lastStep ? hide : () => show(step: _steps[stepNo + 1]),
            child: lastStep ? const Text('Done') : const Text('Next'),
          ),
        ),
      ),
    ];
    return SizedBox(
      width: double.maxFinite,
      height: _kControlsHeight,
      child: Row(
        children: controlsChildren,
      ),
    );
  }

  Widget _buildHelpText(ContextHelpState step) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium!.copyWith(fontSize: 18);
    final bodyStyle = theme.textTheme.bodyMedium!.copyWith(fontSize: 16);
    return SingleChildScrollView(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) => Opacity(
          opacity: _animation.value,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: _kTextMargin,
                  left: _kTextMargin,
                  right: _kTextMargin,
                ),
                child: DefaultTextStyle(
                  style: titleStyle,
                  child: step.widget.title,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(_kTextMargin),
                child: DefaultTextStyle(
                  style: bodyStyle,
                  child: step.widget.body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildren(
    ContextHelpState step,
    _TargetDimensions targetDimensions,
  ) {
    if (!step.widget.highlight) {
      return <Widget>[
        Expanded(
          child: Align(
            child: _buildHelpText(step),
          ),
        ),
        _buildControls(step),
      ];
    }

    final targetBottom =
        targetDimensions.offset.dy + targetDimensions.size.height;
    final screenHeight = MediaQuery.of(context).size.height;
    final targetPositionTop = screenHeight / 2 > targetBottom;

    final spacer = SizedBox(
      width: double.infinity,
      height: targetPositionTop
          ? targetBottom * _kCutoutScaleFactor
          : screenHeight - targetDimensions.offset.dy - _kControlsHeight,
    );

    if (targetPositionTop) {
      return <Widget>[
        spacer,
        Expanded(child: _buildHelpText(step)),
        _buildControls(step),
      ];
    } else {
      return <Widget>[
        Flexible(
            child: Align(
          alignment: Alignment.bottomCenter,
          child: _buildHelpText(step),
        )),
        spacer,
        _buildControls(step),
      ];
    }
  }

  OverlayEntry _buildOverlayForeground(
    ContextHelpState step,
    _TargetDimensions targetDimensions,
  ) =>
      OverlayEntry(
        builder: (context) => SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            children: _buildChildren(step, targetDimensions),
          ),
        ),
      );

  void register(ContextHelpState step) {
    if (_steps.contains(step)) {
      return;
    }
    _steps.add(step);
    notifyListeners();
  }

  void unregister(ContextHelpState step) {
    if (_steps.contains(step)) {
      return;
    }
    _steps.remove(step);
    notifyListeners();
  }

  Future<void> show({ContextHelpState? step}) async {
    if (!active) {
      return;
    }
    step ??= _steps[0];
    await step.ensureVisible();
    if (_overlayEntries.isNotEmpty) {
      await hide();
    }
    if (context.mounted) {
      final overlay = Overlay.of(context);
      // The ancestor is a hack to calculate the correct coordinates for
      // the target, I'd like to remove this if I can work out how.
      final targetDimensions = _TargetDimensions.parse(
        step.context,
        ancestor: context.findRenderObject(),
      );
      final painter =
          _ContextHelpCutoutPainter(step, targetDimensions, _animation.value);
      final background = _buildOverlayBackground(step, targetDimensions);
      final foreground = _buildOverlayForeground(step, painter.dimensions);
      overlay.insert(background);
      _overlayEntries.add(background);
      overlay.insert(foreground);
      _overlayEntries.add(foreground);
      await _animationController.forward().orCancel;
    }
  }

  Future<void> hide() async {
    await _animationController.reverse().orCancel;
    for (final e in _overlayEntries) {
      e.remove();
    }
    _overlayEntries.clear();
  }

  bool get active => _steps.isNotEmpty;

  @override
  void addListener(VoidCallback listener) {
    _notifier.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _notifier.removeListener(listener);
  }

  @protected
  void notifyListeners() {
    _notifier.notify();
  }

  @override
  Widget build(BuildContext context) => _InheritedContextHelpController(
        state: this,
        child: widget.child,
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('active', active));
  }
}

class _ContextHelpCutoutPainter extends CustomPainter {
  _ContextHelpCutoutPainter(this.help, this.targetDimensions, this.cutoutScale);
  final ContextHelpState help;
  final _TargetDimensions targetDimensions;
  final double cutoutScale;
  final _paint = Paint()
    ..color = Colors.transparent
    ..blendMode = BlendMode.clear;

  void _drawCircle(Canvas canvas) {
    final d = dimensions;
    final center = d.size.center(d.offset);
    final radius = d.size.width / 2 * cutoutScale;
    canvas.drawCircle(
      center,
      radius,
      _paint,
    );
  }

  void _drawRectangle(Canvas canvas) {
    final d = dimensions;
    final center = d.size.center(d.offset);
    final width = d.size.width * cutoutScale;
    final height = d.size.height * cutoutScale;
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: width,
        height: height,
      ),
      const Radius.circular(15),
    );
    canvas.drawRRect(rect, _paint);
  }

  void _drawCutout(Canvas canvas) {
    switch (help.widget.shape) {
      case ContextHelpShape.Circle:
        _drawCircle(canvas);
        break;
      case ContextHelpShape.Rectangle:
        _drawRectangle(canvas);
        break;
    }
  }

  _TargetDimensions get dimensions {
    if (!help.widget.highlight) {
      return _TargetDimensions(size: Size.zero, offset: Offset.zero);
    }
    switch (help.widget.shape) {
      case ContextHelpShape.Circle:
        final diameter = sqrt(pow(targetDimensions.size.width, 2) +
                pow(targetDimensions.size.height, 2)) *
            _kCutoutScaleFactor;
        final dx = targetDimensions.offset.dx -
            ((diameter - targetDimensions.size.width) / 2);
        final dy = targetDimensions.offset.dy -
            ((diameter - targetDimensions.size.height) / 2);
        return _TargetDimensions(
          size: Size(diameter, diameter),
          offset: Offset(dx, dy),
        );
      case ContextHelpShape.Rectangle:
        double additionalSize;
        if (targetDimensions.size.width > targetDimensions.size.height) {
          additionalSize = (targetDimensions.size.width * _kCutoutScaleFactor) -
              targetDimensions.size.width;
        } else {
          additionalSize =
              (targetDimensions.size.height * _kCutoutScaleFactor) -
                  targetDimensions.size.height;
        }
        final width = targetDimensions.size.width + additionalSize;
        final height = targetDimensions.size.height + additionalSize;
        final dx = targetDimensions.offset.dx -
            ((width - targetDimensions.size.width) / 2);
        final dy = targetDimensions.offset.dy -
            ((height - targetDimensions.size.height) / 2);
        return _TargetDimensions(
          size: Size(width, height),
          offset: Offset(dx, dy),
        );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..saveLayer(Offset.zero & size, Paint())
      ..drawColor(_kCutoutBackgroundColor, BlendMode.dstATop);
    if (help.widget.highlight) {
      _drawCutout(canvas);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ContextHelpCutoutPainter oldDelegate) =>
      oldDelegate.cutoutScale != cutoutScale;
}

class _TargetDimensions {
  _TargetDimensions({required this.size, required this.offset});

  factory _TargetDimensions.parse(BuildContext context,
      {RenderObject? ancestor}) {
    final renderBox = context.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(
      Offset.zero,
      ancestor: ancestor,
    );
    return _TargetDimensions(size: renderBox.size, offset: offset);
  }
  final Size size;
  final Offset offset;
}

class _ContextHelpNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
