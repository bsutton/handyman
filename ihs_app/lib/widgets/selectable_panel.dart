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
  final bool initiallySelected;
  final String title;
  final Widget child;
  final void Function(bool selected) onSelected;

  SelectablePanel({Key key, this.initiallySelected, this.title, this.child, this.onSelected}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SelectablePanelState(selected: initiallySelected);
  }
}

class SelectablePanelState extends State<SelectablePanel> {
  bool selected = false;

  SelectablePanelState({@required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        buildTitle(),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          NJTextListItem('Selected'),
          Switch(
              value: selected,
              onChanged: (selected) => setState(() {
                    this.selected = selected;
                    widget.onSelected(selected);
                  }))
        ]),
        widget.child
      ]),
    );
  }

  Widget buildTitle() {
    return Selected(
        selected: selected,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          NJTextListItem(widget.title),
        ]));
  }
}

class Selected extends StatelessWidget {
  final Widget child;
  final bool selected;

  Selected({@required this.child, this.selected});
  @override
  Widget build(BuildContext context) {
    return Container(color: getColor(selected: selected), child: child);
  }

  Color getColor({@required bool selected}) {
    return (selected ? Colors.purple : Colors.green);
  }
}
