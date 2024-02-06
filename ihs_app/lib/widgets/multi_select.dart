import 'package:flutter/material.dart';
import 'theme/nj_text_themes.dart';

class MultiSelect<T extends Selectable> extends StatefulWidget {
  final List<T> items;
  final Icon selectedIcon;
  final Icon nonSelectedIcon;
  final Color selectedBackGroundColor;
  final void Function() onChanged;

  MultiSelect(
      {@required this.items, this.selectedIcon, this.nonSelectedIcon, this.selectedBackGroundColor, this.onChanged});

  @override
  State<StatefulWidget> createState() {
    return MultiSelectState<T>(items);
  }
}

abstract class Selectable {
  bool selected = false;

  String get title;
}

class MultiSelectState<T extends Selectable> extends State<MultiSelect> {
  final List<T> items;

  final List<T> selected = [];

  MultiSelectState(this.items);

  @override
  Widget build(BuildContext context) {
    return ListView(children: buildItems());
  }

  List<Widget> buildItems() {
    var widgets = <Widget>[];

    for (var item in items) {
      widgets.add(Container(
          child: SwitchListTile(
              title: NJTextBody(item.title),
              value: item.selected,
              onChanged: (value) {
                setState(() {
                  item.selected = value;
                  widget.onChanged?.call();
                });
              },
              secondary: (item.selected ? widget.selectedIcon : widget.nonSelectedIcon)
              //  Icon(Icons.lightbulb_outline),

              ),
          decoration: BoxDecoration(color: (item.selected ? widget.selectedBackGroundColor : null))));
    }

    return widgets;
  }
}
