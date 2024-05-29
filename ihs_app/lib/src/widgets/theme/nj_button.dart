import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../empty.dart';
import '../svg.dart';
import 'nj_text_themes.dart';

class NJButtonPrimary extends StatelessWidget {
  const NJButtonPrimary({
    required this.label,
    required this.onPressed,
    super.key,
    this.enabled = true,
  })  : svg = null,
        svgColor = null,
        svgLocation = null;

  const NJButtonPrimary.withIcon(
      {required this.label,
      required this.svg,
      super.key,
      this.onPressed,
      this.enabled = true,
      this.svgColor,
      this.svgLocation = LOCATION.vaadin});
  final String label;
  final VoidCallback? onPressed;

  final String? svg;

  final Color? svgColor;

  final LOCATION? svgLocation;

  final bool enabled;

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            disabledForegroundColor: Colors.grey.withOpacity(0.38),
            disabledBackgroundColor: Colors.grey.withOpacity(0.12)),
        onPressed: (enabled ? onPressed : null),
        label: NJTextButton(label),
        icon: svg == null
            ? const Empty()
            : Svg(
                svg!,
                height: 24,
                width: 24,
                location: svgLocation!,
                color: svgColor,
              ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed))
      ..add(StringProperty('svg', svg))
      ..add(ColorProperty('svgColor', svgColor))
      ..add(EnumProperty<LOCATION?>('svgLocation', svgLocation))
      ..add(DiagnosticsProperty<bool>('enabled', enabled));
  }
}

class NJButtonSecondary extends StatelessWidget {
  const NJButtonSecondary(
      {required this.label, required this.onPressed, super.key});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            disabledForegroundColor: Colors.grey.withOpacity(0.38),
            disabledBackgroundColor: Colors.grey.withOpacity(0.12)),
        child: NJTextButton(label),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(StringProperty('label', label))
    ..add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
  }
}
