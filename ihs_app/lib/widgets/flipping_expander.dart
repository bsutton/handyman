import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class FlippingExpander extends StatefulWidget {
  @override
  FlippingExpanderState createState() => FlippingExpanderState();

  final Widget header;
  final Widget front;
  final Widget back;
  final double closedSize;
  final double openSize;
  final Key expanderKey;

  FlippingExpander({this.expanderKey, this.header, this.front, this.back, this.closedSize, this.openSize});
}

enum ExpansionStatus { FRONT_CLOSED, FRONT_OPEN, BACK }

class FlippingExpanderState extends State<FlippingExpander> with SingleTickerProviderStateMixin {
  ExpansionStatus expansionStatus = ExpansionStatus.FRONT_CLOSED;
  final _flipKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          child: getLayout(),
          height: expansionStatus == ExpansionStatus.FRONT_CLOSED ? widget.closedSize : widget.openSize),
    );
  }

  Widget getLayout() {
    return FlipCard(
      direction: FlipDirection.VERTICAL,
      key: _flipKey,
      front: Column(
        children: <Widget>[expansionStatus != ExpansionStatus.BACK ? widget.header : widget.back, widget.front],
      ),
      back: Center(child: widget.back),
      flipOnTouch: false,
    );
  }

  void toggleOpen(void Function(bool open) callback) {
    setState(() {
      if (expansionStatus == ExpansionStatus.FRONT_CLOSED) {
        expansionStatus = ExpansionStatus.FRONT_OPEN;
      } else if (expansionStatus == ExpansionStatus.FRONT_OPEN) {
        expansionStatus = ExpansionStatus.FRONT_CLOSED;
      }
      if (callback != null) {
        callback(expansionStatus == ExpansionStatus.FRONT_OPEN);
      }
    });
  }

  void flip() {
    setState(() {
      _flipKey.currentState.toggleCard();
    });
  }
}
