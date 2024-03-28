import 'package:flutter/material.dart';

import 'svg.dart';

enum Side { left, right }

class SvgText extends StatelessWidget {
  const SvgText(this.path, this.text,
      {super.key,
      this.side = Side.left,
      this.location = LOCATION.icons,
      this.color = Colors.black});
  final String path;
  final String text;
  final Side side;
  final LOCATION location;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (side == Side.left) {
      return Row(children: [
        Svg(path,
            label: 'Flip',
            width: 20,
            height: 20,
            location: location,
            color: color),
        Padding(padding: const EdgeInsets.only(left: 5), child: Text(text))
      ]);
    } else {
      return Row(children: [
        Padding(padding: const EdgeInsets.only(right: 5), child: Text(text)),
        Svg(path,
            label: 'Flip',
            width: 20,
            height: 20,
            location: location,
            color: color)
      ]);
    }
  }
}
