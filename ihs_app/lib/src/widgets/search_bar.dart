import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar(
      {required this.label, required this.onChange, super.key, this.hint = ''});
  final String label;
  final String? hint;
  final ValueChanged<String> onChange;

  @override
  State<StatefulWidget> createState() => SearchBarState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(StringProperty('label', label))
    ..add(StringProperty('hint', hint))
    ..add(
        ObjectFlagProperty<ValueChanged<String>>.has('onChange', onChange));
  }
}

class SearchBarState extends State<SearchBar> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) =>
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>(
        'textController', textController));
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}
