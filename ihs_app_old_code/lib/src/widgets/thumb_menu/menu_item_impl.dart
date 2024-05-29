import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../svg.dart';
import 'menu_item_animator.dart';
import 'menu_item_selected.dart';
import 'thumb_menu.dart';
import 'thumb_menu_imp.dart';

class MenuItemImpl extends StatefulWidget {
  const MenuItemImpl(
      {required this.label,
      required this.svgFilename,
      required this.onTap,
      required this.onNotifyParent,
      required this.degrees,
      super.key});
  static const double imageSize = 60;
  static const double axleYSize = 20;

  final double degrees;
  static const double menuHeight = ThumbMenu.height;
  final String label;
  final String svgFilename;
  final VoidCallback onNotifyParent;
  final VoidCallback onTap;

  @override
  State<StatefulWidget> createState() => MenuItemImplState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DoubleProperty('degrees', degrees))
    ..add(StringProperty('label', label))
    ..add(StringProperty('svgFilename', svgFilename))
    ..add(
        ObjectFlagProperty<VoidCallback>.has('onNotifyParent', onNotifyParent))
    ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}

class MenuItemImplState extends State<MenuItemImpl>
    with SingleTickerProviderStateMixin {
  MenuItemImplState();
  late final double screenWidth;
  late final double screenHeight;
  late final double axleXSize;

  @override
  void initState() {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    axleXSize = min(mmToPixels(15), screenWidth / 2 - MenuItemImpl.imageSize);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final itemXSize = axleXSize + MenuItemImpl.imageSize / 3;
    const itemYSize = MenuItemImpl.imageSize;

    // the center of rotation is normally at the center
    // if the item. We need to move it to the bottom centre
    final xOrigin = itemXSize / 2 + 20;
    const yOrigin = 0.0;

    const yPosition = (ThumbMenuImpl.circleBottom +
            ThumbMenuImpl.circleDiameter -
            itemYSize) /
        2;

    return Positioned(
        // centres the base of the item over the centre of the thumb 
        //memu circle as the point of rotation.
        right: screenWidth / 2,
        bottom: yPosition,
        child: buildAxleAndImage(xOrigin, yOrigin));
  }

  // Log.d("Consumer for ${widget.label} being built");
  Consumer<MenuItemAnimator> buildAxleAndImage(
          double xOrigin, double yOrigin) =>
      Consumer<MenuItemAnimator>(
          builder: (context, animator, _) =>
              rotate(context, animator, xOrigin, yOrigin));

  Widget rotate(BuildContext context, MenuItemAnimator animator, double xOrigin,
      double yOrigin) {
    // Log.d("Menu current: ${widget.label}");
    // to allow the animation curvature to 'overshoot' the target location
    final curvatureOvershoot = max(MenuItemAnimator.min,
        widget.degrees + animator.itemRotator.value - MenuItemAnimator.max);

    final angle = min(curvatureOvershoot, animator.itemRotator.value);

//      Log.d("Menu current: ${widget.label} tween:${animator.itemRotator
//           .value} limit: $angle overshoot:  $curvatureOvershoot");
    return Transform.rotate(
        angle: degreesToRadians(angle),
        origin: Offset(xOrigin, yOrigin),
        child: Row(children: [buildImage(animator), buildAxle()]));
  }

  Widget buildAxle() => SizedBox(
        width: axleXSize,
        height: MenuItemImpl.axleYSize,
        // color: Colors.red,  // add the color and text back in to debug the menu item rotation.
        //  child: Text(widget.degrees.ceil().toString())
      );

  Widget buildImage(MenuItemAnimator animator) => rotateImage(
      rotation: animator.itemRotator.value,
      child: Consumer<MenuItemSelected>(
          builder: (context, selected, _) => GestureDetector(
              onTap: onSelected,
              child: Column(children: [buildLabel(), buildSvg(selected)]))));

  Container buildSvg(MenuItemSelected selected) {
    final Color borderColor =
        (selected.isSelected(this) ? Colors.red : Colors.orange);

    return Container(
        decoration: BoxDecoration(
          color: borderColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 3),
        ),
        height: MenuItemImpl.imageSize + 5,
        width: MenuItemImpl.imageSize + 5,
        child: SizedBox(
            width: MenuItemImpl.imageSize,
            height: MenuItemImpl.imageSize,
            child: Svg(widget.svgFilename,
                height: MenuItemImpl.imageSize,
                width: MenuItemImpl.imageSize)));
  }

  Widget buildLabel() {
    const color = Colors.lightBlueAccent;
    return //

        Padding(
            padding: const EdgeInsets.all(4),
            child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(2, 2),
                        blurRadius: .2)
                  ],
                ),
                child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(widget.label,
                        style: const TextStyle(
                            backgroundColor: color, fontSize: 14)))));
  }

  Widget rotateImage({required double rotation, required Widget child}) {
    final limit = -min(rotation, widget.degrees);

    return Transform.rotate(angle: degreesToRadians(limit), child: child);
  }

  double degreesToRadians(double degrees) => degrees * 3.1415927 / 180;

  void onSelected() {
    widget.onNotifyParent();
    widget.onTap();
  }

  @override
  void dispose() {
    // animationController.dispose();
    super.dispose();
  }

  double mmToPixels(int millimetres) => millimetres * 6.299;
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DoubleProperty('screenWidth', screenWidth))
    ..add(DoubleProperty('screenHeight', screenHeight))
    ..add(DoubleProperty('axleXSize', axleXSize));
  }
}
