import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {

  const SearchBar({required this.label, required this.onChange, super.key, this.hint = ''});
  final String label;
  final String? hint;
  final ValueChanged<String> onChange;

  @override
  State<StatefulWidget> createState() => SearchBarState();
}


class SearchBarState extends State<SearchBar> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      // Text(widget.label),
      Expanded(
          child: TextField(
              onChanged: widget.onChange,
              controller: textController,
              decoration: InputDecoration(
                  labelText: widget.label, hintText: widget.hint))),
      SmallButton(onPressed: clear, child: const Text('X'))
    ]);

  void clear() {
    textController.clear();
    widget.onChange('');
  }
}

class SmallButton extends StatelessWidget {

  const SmallButton({required this.onPressed, required this.child, super.key});
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final buttonTheme = ButtonTheme.of(context)
        .copyWith(minWidth: 30, height: 30, padding: EdgeInsets.zero);

    return ButtonTheme.fromButtonThemeData(
        data: buttonTheme,
        child: ElevatedButton(onPressed: onPressed, child: child));
  }
}
