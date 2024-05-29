import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/log.dart';
import '../expansion_bottom_app_bar/expansion_bottom_app_bar.dart';
import 'menu_item.dart';
import 'menu_item_animator.dart';
import 'menu_items.dart';
import 'menu_open_state.dart';
import 'thumb_menu.dart';
import 'thumb_menu_imp.dart';
import 'thumb_menu_scaffold.dart';

class ThumbMenuOverlay extends StatefulWidget {
  const ThumbMenuOverlay(this.title, this.menuItems, this.expansionMenuKey,
      {super.key});
  final String title;
  final List<MenuItem> menuItems;
  final GlobalKey<ExpansionBottomAppBarState>? expansionMenuKey;

  @override
  State<StatefulWidget> createState() => ThumbMenuOverlayState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(IterableProperty<MenuItem>('menuItems', menuItems))
      ..add(DiagnosticsProperty<GlobalKey<ExpansionBottomAppBarState>?>(
          'expansionMenuKey', expansionMenuKey));
  }
}

class ThumbMenuOverlayState extends State<ThumbMenuOverlay>
    with TickerProviderStateMixin {
  bool menuOpen = false;

  late final AnimationController circleAnimator;
  late final Animation<double> growCircle;
  late final Tween<double> diameterTween;

  GlobalKey<ThumbMenuState> circleKey = GlobalKey<ThumbMenuState>();

  @override
  void initState() {
    super.initState();

    circleAnimator = AnimationController(
        duration: const Duration(milliseconds: MenuItemAnimator.duration ~/ 4),
        vsync: this);

    // used to grow the circle when some one clicks on it.
    diameterTween = Tween<double>(
        begin: ThumbMenuImpl.circleDiameter,
        end: ThumbMenuImpl.circleDiameter * 1.1);

    growCircle = diameterTween.animate(circleAnimator);

    growCircle.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = MenuItems(widget.menuItems, onSelected, closeMenu);
    final screenWidth = MediaQuery.of(context).size.width;

    return
        //   Material(color: null, child:
        GestureDetector(
            onTap: () => toggleMenu(menuItems),
            child: Overlay(initialEntries: [
              OverlayEntry(builder: (context) => menuItems),
              OverlayEntry(
                  // make certain this container ONLY covers the menu title.
                  builder: (context) => Positioned(
                      bottom: 0,
                      left: 0,
                      child: Material(
                          child: Container(
                              constraints: BoxConstraints(
                                  maxHeight: ThumbMenu.height,
                                  maxWidth: screenWidth),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  buildTitle(1, screenWidth),
                                  buildCircle(screenWidth),
                                  buildTitle(0.65, screenWidth),
                                ],

                                /// overflow: Overflow.visible, defaults
                                /// to Clip.none which should be the same.
                              )))))
            ])
            // )
            );
  }

  void toggleMenu(MenuItems menuItems) {
    if (menuOpen == false) {
      Provider.of<MenuOpenState>(context, listen: false).open();
      Provider.of<MenuItemAnimator>(context, listen: false).open();

      menuOpen = true;
    } else {
      closeMenu();
    }
  }

  void closeMenu() {
    menuOpen = false;
    // once the animation is complete we remove the menu items.
    // CONSIDER: does this cause a problem if the user
    // is trying to click on the background whilst the menu
    // items are still closing?
    Provider.of<MenuItemAnimator>(context, listen: false)
        .close(() => Provider.of<MenuOpenState>(context).close());
  }

  void onOverlayTapped() {
    Log.d('overlay tapped');
  }

  Widget buildTitle(double opacity, double screenWidth) {
    MediaQuery.of(context).size.width;
    return Positioned(
        bottom: 0,
        left: 0,
        width: screenWidth,
        child: Stack(
          clipBehavior: Clip.none,
          children: getTitleComponents(opacity),
        ));
  }

  Widget buildHamburger() => IconButton(
      icon: const Icon(Icons.menu),
      color: Theme.of(context).buttonTheme.colorScheme!.onPrimary,
      onPressed: toggleQuickList);

  void toggleQuickList() {
    ThumbMenuScaffold.expansionBar().toggle();
  }

  Widget buildCircle(double screenWidth) =>
      Consumer<MenuOpenState>(builder: (context, state, _) {
        final ab = AnimatedBuilder(
            animation: circleAnimator,
            builder: (context, child) => buildCircle2(screenWidth));

        if (state.isOpen) {
          circleAnimator.forward();
        } else {
          circleAnimator.reverse();
        }

        return ab;
      });

  Widget buildCircle2(double screenWidth) {
    const Color color = Colors.purple; // Theme.of(context).primaryColor,

    return Positioned(
        bottom: ThumbMenuImpl.circleBottom,
        left: (screenWidth - growCircle.value) / 2,
        child: Container(
          key: circleKey,
          width: growCircle.value,
          height: growCircle.value,
          decoration: const BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    //  offset: Offset(-0, -5),
                    //blurRadius: 2.0,
                    color: Colors.grey)
              ]),
        ));
  }

  List<Widget> getTitleComponents(double opacity) {
    final widgets = <Widget>[];

    // ignore: cascade_invocations
    widgets
      ..add(ThumbMenuTitle(title: widget.title, opacity: opacity))
      ..add(buildNoticeChip())
      ..add(buildTodoChip());

    return widgets;
  }

  Widget buildNoticeChip() => const Positioned(
      bottom: ThumbMenu.height - 30,
      left: 70,
      child: Chip(
        label: Text('5'),
        backgroundColor: Colors.orange,
        elevation: 7,
      ));

  Widget buildTodoChip() => Positioned(
      bottom: ThumbMenu.height - 30,
      left: 20,
      child: GestureDetector(
          onTap: onTodo,
          child: const Chip(
            label: Text('2'),
            backgroundColor: Colors.yellow,
            elevation: 7,
          )));

  ///
  /// A user clicked on a menu item.
  ///
  void onSelected() {
    closeMenu();
  }

  @override
  void dispose() {
    circleAnimator.dispose();
    super.dispose();
  }

  void onTodo() {
    Log.d('TODO clicked');
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<GlobalKey<ThumbMenuState>>(
          'circleKey', circleKey))
      ..add(DiagnosticsProperty<bool>('menuOpen', menuOpen))
      ..add(DiagnosticsProperty<AnimationController>(
          'circleAnimator', circleAnimator))
      ..add(DiagnosticsProperty<Animation<double>>('growCircle', growCircle))
      ..add(DiagnosticsProperty<Tween<double>>('diameterTween', diameterTween));
  }
}
