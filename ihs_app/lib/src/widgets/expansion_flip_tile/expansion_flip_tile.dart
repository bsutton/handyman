import 'dart:math';

import 'package:flip/flip.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const EdgeInsets _defaultContentPadding = EdgeInsets.all(16);
const double _flipControlWidth = 50;

class _ExpansionFlipTilePageState {
  _ExpansionFlipTilePageState();
  bool hasExpanded = false;
  bool hasFlipped = false;
}

class ExpansionFlipTile extends StatefulWidget {
  const ExpansionFlipTile(
      {required this.title,
      required this.bodyBuilder,
      required this.actionBuilder,
      super.key,
      this.swatch});
  final Widget title;
  final MaterialColor? swatch;
  final WidgetBuilder bodyBuilder;
  final WidgetBuilder actionBuilder;

  @override
  ExpansionFlipTileState createState() => ExpansionFlipTileState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<WidgetBuilder>.has('bodyBuilder', bodyBuilder))
      ..add(
          ObjectFlagProperty<WidgetBuilder>.has('actionBuilder', actionBuilder))
      ..add(ColorProperty('swatch', swatch));
  }
}

class ExpansionFlipTileState extends State<ExpansionFlipTile> {
  _ExpansionFlipTilePageState _pageState = _ExpansionFlipTilePageState();
  final _flipController = FlipController();

  @override
  void initState() {
    super.initState();
    _pageState = PageStorage.of(context).readState(context)
            as _ExpansionFlipTilePageState? ??
        _pageState;
    _flipController.addListener(_handleFlip);
  }

  void _handleExpansion(bool value) {
    if (value && !_pageState.hasExpanded) {
      setState(() {
        _pageState.hasExpanded = true;
        PageStorage.of(context).writeState(context, _pageState);
      });
    }
  }

  void _handleFlip() {
    final value = _flipController.value;
    if (value && !_pageState.hasFlipped) {
      setState(() {
        _pageState.hasFlipped = true;
        PageStorage.of(context).writeState(context, _pageState);
      });
    }
  }

  List<Widget> _buildChildren(BuildContext context) {
    const empty = SizedBox(height: 0, width: double.infinity);
    Widget body = empty;
    Widget actions = empty;
    if (_pageState.hasExpanded) {
      body = Align(
        alignment: Alignment.centerLeft,
        child: widget.bodyBuilder(context),
      );
    }
    actions = widget.actionBuilder(context);
    /*
    TODO: Work out this race condition
    if (_pageState.hasFlipped && widget.actionBuilder != null) {
      actions = widget.actionBuilder(context);
    }
    */
    return <Widget>[
      Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            width: _flipControlWidth,
            child: Material(
              color: widget.swatch?.shade500 ??
                  Theme.of(context).colorScheme.surface,
              child: InkWell(
                onTap: _flipController.flip,
                child: SizedBox(
                  width: _flipControlWidth,
                  child: Transform.rotate(
                    angle: 90 * pi / 180.0,
                    child: const Icon(Icons.flip),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: _flipControlWidth),
            child: ColoredBox(
              color: widget.swatch!.shade700,
              child: Padding(
                padding: _defaultContentPadding,
                child: Flip(
                  flipDirection: Axis.vertical,
                  controller: _flipController,
                  firstChild: body,
                  secondChild: actions,
                ),
              ),
            ),
          ),
        ],
      )
    ];
  }

  Widget _buildTile(BuildContext context) => ExpansionTile(
        backgroundColor: widget.swatch!.shade800,
        onExpansionChanged: _handleExpansion,
        title: widget.title,
        children: _buildChildren(context),
      );

  @override
  Widget build(BuildContext context) {
    final _headerColor =
        widget.swatch == null ? Colors.transparent : widget.swatch!.shade800;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: _headerColor,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _headerColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: _buildTile(context),
        ),
      ),
    );
  }
}
