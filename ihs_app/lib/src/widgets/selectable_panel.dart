import 'package:flutter/material.dart';

import 'theme/nj_text_themes.dart';

/// Builds a panel that contains a three rows
/// A title
/// A row that contains the word 'Selected' and a [Switch]
/// The child
///
/// The [onSelected] callback is fired when a use activates the switch
/// The [initiallySelected] paramter controls whether the swtich is initial
/// on.
class SelectablePanel extends StatefulWidget {
  const SelectablePanel(
      {required this.initiallySelected,
      required this.title,
      required this.child,
      required this.onSelected,
      super.key});
  final bool initiallySelected;
  final String title;
  final Widget child;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool selected) onSelected;
  @override
  State<StatefulWidget> createState() => SelectablePanelState();
}

class SelectablePanelState extends State<SelectablePanel> {
  SelectablePanelState() {
    selected = widget.initiallySelected;
  }

  late bool selected;
  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Colors.green,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          buildTitle(),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            const NJTextListItem('Selected'),
            Switch(
                value: widget.initiallySelected,
                onChanged: (selected) => setState(() {
                      this.selected = selected;
                      widget.onSelected(selected);
                    }))
          ]),
          widget.child
        ]),
      );

  Widget buildTitle() => Selected(
      selected: selected,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            NJTextListItem(widget.title),
          ]));
}

class Selected extends StatelessWidget {
  const Selected({required this.child, required this.selected, super.key});
  final Widget child;
  final bool selected;
  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: getColor(selected: selected), child: child);

  Color getColor({required bool selected}) =>
      (selected ? Colors.purple : Colors.green);
}
