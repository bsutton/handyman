import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../empty.dart';
import 'expansion_flip_tile.dart';

final Random _rand = Random();
const double _shimmerHeight = 12;
const double _borderRadius = _shimmerHeight / 2.5;
const double _spacerWidth = _shimmerHeight / 2.0;

class ExpansionFlipTileSkeleton extends StatelessWidget {
  const ExpansionFlipTileSkeleton({super.key, this.swatch});
  final MaterialColor? swatch;

  double _width(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final minWidth = screenWidth * 0.08;
    var width = screenWidth * 0.3 * _rand.nextDouble();
    if (width < minWidth) {
      width = minWidth;
    }
    return width;
  }

  @override
  Widget build(BuildContext context) => ExpansionFlipTile(
      swatch: swatch,
      bodyBuilder: (context) => const Empty(),
      actionBuilder: (context) => const Empty(),
      title: Shimmer.fromColors(
        baseColor: Colors.white70,
        highlightColor: Colors.white38,
        child: Row(
          children: <Widget>[
            Container(
              width: _width(context),
              height: _shimmerHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: _spacerWidth),
              width: _width(context),
              height: _shimmerHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
            ),
          ],
        ),
      ),
    );
}
