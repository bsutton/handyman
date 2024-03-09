import 'package:flutter/material.dart';
import 'svg.dart';

enum Side { LEFT, RIGHT }

class SvgText extends StatelessWidget {
  final String path;
  final String text;
  final Side side;
  final LOCATION location;
  final Color color;

  SvgText(this.path, this.text, {this.side = Side.LEFT, this.location = LOCATION.ICONS, this.color});

  @override
  Widget build(BuildContext context) {
    if (side == Side.LEFT) {
      return Row(children: [
        Svg(path, label: 'Flip', width: 20, height: 20, location: location, color: color),
        Padding(child: Text(text), padding: EdgeInsets.only(left: 5))
      ]);
    } else {
      return Row(children: [
        Padding(child: Text(text), padding: EdgeInsets.only(right: 5)),
        Svg(path, label: 'Flip', width: 20, height: 20, location: location, color: color)
      ]);
    }
  }
}
