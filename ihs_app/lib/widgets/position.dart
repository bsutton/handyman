import 'package:flutter/material.dart';
import 'theme/nj_theme.dart';

enum TopOrTailPlacement { top, bottom }

///
/// Provide a simle method of positioning a widget
/// which is a child of a Stack at either
/// the top or bottom of the page.
class TopOrTail extends StatelessWidget {
  final Widget child;
  final TopOrTailPlacement placement;
  TopOrTail({this.placement, this.child});

  @override
  Widget build(BuildContext context) {
    if (placement == TopOrTailPlacement.bottom) {
      return Positioned(bottom: 5, right: NJTheme.padding, child: child);
    } else {
      return Positioned(top: 5, right: NJTheme.padding, child: child);
    }
  }
}
