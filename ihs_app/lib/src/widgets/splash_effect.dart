import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashEffect extends StatelessWidget {
  const SplashEffect({required this.child, required this.onTap, super.key});
  final Widget child;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          onTap: onPressed,
          child: child,
        ),
      );

  void onPressed() {
    onTap();
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<void Function()>.has('onTap', onTap));
  }
}
