import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum LOCATION { VAADIN, ICONS }

class Svg extends StatelessWidget {
  final String filename;
  final String label;
  final double width;
  final double height;
  final LOCATION location;
  final void Function() onTap;
  final Color color;

  static const VAADIN_ASSET = 'assets/vaadin-svg/';
  static const ICON_ASSET = 'assets/icons/';

  ///
  /// We are having sizing problems.
  /// The aim is to have the SVG fill its parent if the width/height are not specified.
  /// The issue is that if a column(?) with infinite height if we don't
  /// provide a hieght we get a nasty error out of flutter (even though the svg
  /// renders as expected).
  /// The default sizes here are a hack around the problem.
  ///
  Svg(this.filename,
      {this.label, this.width = 80, this.height = 80, this.location = LOCATION.ICONS, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return buildSvg();
  }

  Widget buildSvg() {
/*
    return FittedBox(`
      fit: BoxFit.scaleDown,
      child: buildTree()

    );
    */

    return SizedBox(width: width, height: height, child: buildTree());
  }

  Widget buildTree() {
    Widget tree;

    if (onTap != null) {
      tree = GestureDetector(onTap: onTap, child: buildAsset());
    } else {
      tree = buildAsset();
    }
    return tree;
  }

  Widget buildAsset() {
    var finalPath = getPath(filename);
    return SvgPicture.asset(finalPath, semanticsLabel: label, width: width, height: height, color: color);
  }

  String getPath(String filename) {
    String path;
    switch (location) {
      case LOCATION.VAADIN:
        path = VAADIN_ASSET;
        break;
      case LOCATION.ICONS:
        path = ICON_ASSET;
        break;
    }

    var extension = '';
    if (!filename.endsWith('.svg')) {
      extension = '.svg';
    }

    return path + filename + extension;
  }
}
