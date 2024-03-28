import 'package:flutter/material.dart';

import 'theme/nj_text_themes.dart';

class MultiSelect<T extends Selectable> extends StatefulWidget {

  const MultiSelect(
      {required this.items, required this.nonSelectedIcon, required this.selectedIcon, required this.selectedBackGroundColor, super.key,
       this.onChanged});
  final List<T> items;
  final Icon selectedIcon;
  final Icon nonSelectedIcon;
  final Color selectedBackGroundColor;
  final void Function()? onChanged;

  @override
  State<StatefulWidget> createState() => MultiSelectState<T>();
}

abstract class Selectable {
  bool selected = false;

  String get title;
}

class MultiSelectState<T extends Selectable> extends State<MultiSelect> {

  MultiSelectState();

  final List<T> selected = [];

  @override
  Widget build(BuildContext context) => ListView(children: buildItems());

  List<Widget> buildItems() {
    final widgets = <Widget>[];

    for (final item in widget.items) {
      widgets.add(DecoratedBox(
          decoration: BoxDecoration(
              color: (item.selected ? widget.selectedBackGroundColor : null)),
          child: SwitchListTile(
              title: NJTextBody(item.title),
              value: item.selected,
              onChanged: (value) {
                setState(() {
                  item.selected = value;
                  widget.onChanged?.call();
                });
              },
              secondary:
                  (item.selected ? widget.selectedIcon : widget.nonSelectedIcon)
              //  Icon(Icons.lightbulb_outline),

              )));
    }

    return widgets;
  }
}
