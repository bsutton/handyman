import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../widgets/flipping_expander.dart';
import '../../widgets/svg.dart';
import '../../widgets/svg_text.dart';
import '../../widgets/undomanager/undo_manager_notifier.dart';
import 'contact.dart';
import 'contact_editor.dart';

class ContactCard extends DeletableItem {
  ContactCard(this.contact) : super(ValueKey<String>(contact.id!));
  final Contact contact; // ,  this.onRemove);

  @override
  State<StatefulWidget> createState() => _ContactCardState();

  @override
  Future<void> delete() async {
    await contact.document!.reference.delete();
  }

  @override
  String getDescription() => contact.getDescription();
}

class _ContactCardState extends State<ContactCard>
    with SingleTickerProviderStateMixin {
  _ContactCardState() {
    contact = widget.contact;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _easeInAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _iconTurns = Tween<double>(begin: 0, end: 0.5).animate(_easeInAnimation);
  }
  late final Contact contact;

  static const double closedSize = 50;
  static const double openSize = 100;
  static const double bodySize = openSize - closedSize;

  static const Color headerColor = Colors.orange;
  static const Color bodyColor = Colors.orangeAccent;
  static const Color backColor = Colors.lime;

  late AnimationController _controller;
  late CurvedAnimation _easeInAnimation;
  late Animation<double> _iconTurns;

  final _flipKey = GlobalKey<FlippingExpanderState>();

  @override
  Widget build(BuildContext context) => Container(
      margin: getMargin(),
      child: FlippingExpander(
          expanderKey: _flipKey,
          header: header(),
          front: body(),
          back: buildBack(context),
          closedSize: closedSize,
          openSize: openSize));

  EdgeInsets getMargin() => const EdgeInsets.only(top: 2);

  void onHistory() {}

  Future<void> onEdit() async {
    await showModalBottomSheet<ContactEditor>(
        isScrollControlled: true,
        context: context,
        builder: (context) => ContactEditor(contact));
  }

  Future<void> onDelete(BuildContext context) async {
    await Provider.of<UndoManagerNotifier>(context, listen: false)
        .markForDelete(widget, context);
    // request that we are removed from the list.
    // we won't actually be deleted until the timeout expires.
    // this.removeCallback(widget.contact);
  }

  Widget header() => InkWell(
        child: Container(
            height: closedSize,
            padding: const EdgeInsets.only(left: 5),
            color: headerColor,
            child: DefaultTextStyle(
                style: const TextStyle(color: Colors.black, fontSize: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(contact.getName()),
                      Text(contact.getCompany()),
                      RotationTransition(
                        turns: _iconTurns,
                        child: const Icon(Icons.expand_more),
                      )
                    ]))),
        onTap: () {
          _flipKey.currentState!.toggleOpen.call((open) {
            if (open) {
              _controller.forward();
            } else {
              _controller.animateBack(0);
            }
          });
        },
      );

  Widget body() => Container(
      color: bodyColor,
      height: bodySize,
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.black, fontSize: 20),
        child: Row(children: <Widget>[
          buildSvg('assets/vaadin-svg/flip-v.svg'),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: contact.getMobile,
                          child: Center(
                            child: SvgText('mobile.svg', contact.getMobile(),
                                location: LOCATION.vaadin),
                          ),
                        ),
                        InkWell(
                          onTap: contact.getLandline,
                          child: Center(
                            child: SvgText(
                                'phone-landline.svg', contact.getLandline(),
                                location: LOCATION.vaadin, side: Side.right),
                          ),
                        )
                      ])))
        ]),
      ));

  Widget buildBack(BuildContext context) => Container(
      color: backColor,
      height: openSize,
      child: Row(children: [
        Column(children: [
          Expanded(child: buildSvgForBack('assets/vaadin-svg/flip-v.svg'))
        ]),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: onHistory, child: const Text('History')),
              ElevatedButton(
                onPressed: onEdit,
                child: const Text('Edit'),
              ),
              ElevatedButton(
                  child: const Text('Delete'),
                  onPressed: () async => onDelete(context)),
            ],
          ),
        ))
      ]));

  Widget buildSvg(String path) => GestureDetector(
      onTap: doFlip,
      child: Container(
        decoration: const BoxDecoration(color: Colors.lightBlueAccent),
        //),
        width: 40,
        height: bodySize,
        child: FittedBox(
            fit: BoxFit.scaleDown,
            //child: Hero(
            //  tag: "flip",
            child: SvgPicture.asset(path,
                semanticsLabel: 'Flip', width: 20, height: 20)),
      ));

  Widget buildSvgForBack(String path) => GestureDetector(
      onTap: doFlip,
      child: Container(
        decoration: const BoxDecoration(color: Colors.lightBlueAccent),
        //),
        width: 40,
        height: 40,
        child: FittedBox(
            fit: BoxFit.scaleDown,
            //  child: Hero(
            //    tag: "flip",
            child: SvgPicture.asset(
              path,
              semanticsLabel: 'Flip',
              width: 20,
            )),
      ));

  void doFlip() {
    _flipKey.currentState!.flip();
  }
}
