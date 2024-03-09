import 'package:flutter/material.dart';
import 'theme/nj_theme.dart';

/// Wraps a TextField and a TextEditingController into a simple to use package.
class TextFieldNJ extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String initialValue;
  final TextInputType keyboardType;
  final String hintText;
  final EdgeInsets padding;
  final bool Function(String text) validator;
  final String Function(String text) errorMessage;
  final String label;
  final FocusNode focusNode;
  final List<String> autofillHints;

  final TextCapitalization textCapitalization;

  /// Color of the label
  final Color labelColor;

  const TextFieldNJ(
      {Key key,
      this.labelColor,
      this.onChanged,
      this.initialValue,
      this.keyboardType = TextInputType.text,
      this.hintText,
      this.padding,
      this.validator,
      this.errorMessage,
      this.label,
      this.focusNode,
      this.textCapitalization = TextCapitalization.none,
      this.autofillHints})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return TextFieldNJState(initialValue);
  }
}

class TextFieldNJState extends State<TextFieldNJ> {
  TextEditingController textController;
  String errorText = '';

  EdgeInsets defaultPadding = EdgeInsets.only(bottom: 20);
  TextFieldNJState(String initialValue) {
    textController = TextEditingController(text: initialValue);
  }

  bool isValid = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding ?? defaultPadding,
        child: TextField(
            autofillHints: widget.autofillHints,
            controller: textController,
            style: TextStyle(color: NJColors.errorBackground),
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: TextStyle(color: NJColors.fieldLabel),
              errorText: errorText,
              hintText: widget.hintText,

              //hintStyle: TextStyle(color: Colors.purple)
            ),
            keyboardType: widget.keyboardType,
            onChanged: changeHandler,
            focusNode: widget.focusNode,
            textCapitalization: widget.textCapitalization));
  }

  void changeHandler(String value) {
    if (widget.onChanged != null) {
      widget.onChanged(value);

      if (widget.validator != null) {
        setState(() {
          isValid = widget.validator(textController.text);
          errorText = isValid ? null : widget.errorMessage(value);
        });
      }
    }
  }
}
