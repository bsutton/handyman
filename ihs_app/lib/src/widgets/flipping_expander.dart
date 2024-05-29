import 'package:flip_card/flip_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FlippingExpander extends StatefulWidget {
  const FlippingExpander(
      {required this.expanderKey,
      required this.header,
      required this.front,
      required this.back,
      required this.closedSize,
      required this.openSize,
      super.key});
  @override
  FlippingExpanderState createState() => FlippingExpanderState();

  final Widget header;
  final Widget front;
  final Widget back;
  final double closedSize;
  final double openSize;
  final Key expanderKey;
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DoubleProperty('closedSize', closedSize))
    ..add(DoubleProperty('openSize', openSize))
    ..add(DiagnosticsProperty<Key>('expanderKey', expanderKey));
  }
}

enum ExpansionStatus { frontClosed, frontOpen, back }

class FlippingExpanderState extends State<FlippingExpander>
    with SingleTickerProviderStateMixin {
  ExpansionStatus expansionStatus = ExpansionStatus.frontClosed;
  final _flipKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: expansionStatus == ExpansionStatus.frontClosed
                ? widget.closedSize
                : widget.openSize,
            child: getLayout()),
      );

  Widget getLayout() => FlipCard(
        direction: FlipDirection.VERTICAL,
        key: _flipKey,
        front: Column(
          children: <Widget>[
            if (expansionStatus != ExpansionStatus.back)
              widget.header
            else
              widget.back,
            widget.front
          ],
        ),
        back: Center(child: widget.back),
        flipOnTouch: false,
      );

  // ignore: avoid_positional_boolean_parameters
  void toggleOpen(void Function(bool open) callback) {
    setState(() {
      if (expansionStatus == ExpansionStatus.frontClosed) {
        expansionStatus = ExpansionStatus.frontOpen;
      } else if (expansionStatus == ExpansionStatus.frontOpen) {
        expansionStatus = ExpansionStatus.frontClosed;
      }
      callback(expansionStatus == ExpansionStatus.frontOpen);
    });
  }

  void flip() {
    setState(() async {
      await _flipKey.currentState?.toggleCard();
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(EnumProperty<ExpansionStatus>('expansionStatus', expansionStatus));
  }
}
