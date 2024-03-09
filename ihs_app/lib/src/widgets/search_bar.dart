import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final String label;
  final String hint;
  final ValueChanged<String> onChange;

  SearchBar({@required this.label, @required this.onChange, this.hint = ''});

  @override
  State<StatefulWidget> createState() {
    return SearchBarState();
  }
}

class SearchBarState extends State<SearchBar> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      // Text(widget.label),
      Expanded(
          child: TextField(
              onChanged: widget.onChange,
              controller: textController,
              decoration: InputDecoration(
                  labelText: widget.label, hintText: widget.hint))),
      SmallButton(child: Text('X'), onPressed: clear)
    ], crossAxisAlignment: CrossAxisAlignment.end);
  }

  void clear() {
    textController.clear();
    widget.onChange('');
  }
}

class SmallButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  SmallButton({@required this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    final buttonTheme = ButtonTheme.of(context)
        .copyWith(minWidth: 30.0, height: 30, padding: EdgeInsets.all(0));

    return ButtonTheme.fromButtonThemeData(
        data: buttonTheme,
        child: ElevatedButton(child: child, onPressed: onPressed));
  }
}
