import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/router.dart';
import '../util/log.dart';
import 'splash_effect.dart';
import 'theme/nj_text_themes.dart';
import 'thumb_menu/menu_open_state.dart';

enum DashletAlignment { left, right, centre }

typedef OnPressedCallback = RouteName Function();

class Dashlet extends StatelessWidget {
  // final BuildContext parentContext;

  ///
  /// chipText - the text to show in a chip in the upper right corner of the dashlet.
  ///             If the chipText is null then the chip will not be shown.
  const Dashlet(
      { // required this.parentContext,
      required this.svgImage,
      required this.label,
      super.key,
      this.width = 100,
      this.chipText,
      this.chipColor,
      this.flex = 1,
      this.backgroundColor = Colors.blueAccent,
      this.alignment = DashletAlignment.centre,
      this.targetRoute,
      this.replaceRoute = false,
      this.onPressed,
      this.heroTag})
      : assert(targetRoute == null, 'bad');
  final Widget svgImage;
  final String label;
  final double width;
  static const double height = 60;
  final String? chipText;
  final Color? chipColor;

  final Color backgroundColor;
  final int flex;

  final DashletAlignment alignment;

  static const double iconHeightNormal = height;
  static const double iconHeightSmall = height / 2;

  // The route target to push on to the nav stack when the dahslet is clicked.
  final RouteName? targetRoute;

  // if true we replace the route rathen than pushing it on to the stack.
  final bool replaceRoute;

  /// We recommend that you use targetRoute rather than onPressed unless you have
  /// some specialise processing that you need to do or the route target is dynamic.
  final GestureTapCallback? onPressed;

  final String? heroTag;

  @override
  Widget build(BuildContext context) => Expanded(
      flex: flex,
      child: Padding(
          padding: const EdgeInsets.all(
              4), // creates negative space (black border) between each dashlet.
          child: Stack(children: [buildContent(context), buildChip(context)])));

  Widget buildChip(BuildContext context) => Positioned(
      top: 0,
      right: 4,
      child: GestureDetector(
          onTap: () => onTap(context),
          child: Chip(
              label: NJTextChip(chipText ?? ''),
              backgroundColor: chipColor,
              labelStyle: const TextStyle(fontSize: 12, color: Colors.black),
              elevation: 7,
              padding: EdgeInsets.zero)));

  void doPressed() {
    Log.d('doPressed');
  }

  Widget buildContent(BuildContext context) => DecoratedBox(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(2))),
      child: SplashEffect(
          onTap: () => onTap(context),
          child:
              // blue border around content.
              Padding(
                  padding: const EdgeInsets.all(4),
                  child: buildLabelAndSvg())));

  Widget buildLabelAndSvg() {
    switch (alignment) {
      case DashletAlignment.right:
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [buildLabel(), svgImage]);

      case DashletAlignment.left:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.all(2),
              child: Align(alignment: Alignment.centerLeft, child: svgImage)),
          buildLabel()
        ]);

      // ignore: no_default_cases
      default:
        /// (centre)
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.all(2), child: Center(child: svgImage)),
          buildLabel()
        ]);
    }
  }

  Widget placeImage() {
    if (alignment == DashletAlignment.right) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            flex: flex,
            child: svgImage,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            flex: flex,
            child: svgImage,
          ),
        ],
      );
    }
  }

  void onTap(BuildContext context) {
    Log.d('Dashlet: $label onTap');
    Provider.of<MenuOpenState>(context, listen: false).close();

    onPressed?.call();
  }

  Widget buildLabel() => Text(label,
      textAlign: TextAlign.left,
      style: const TextStyle(fontSize: 15, color: Colors.white));
}
