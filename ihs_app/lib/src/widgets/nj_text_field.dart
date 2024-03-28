import 'package:flutter/material.dart';

import 'theme/nj_theme.dart';

/// Wraps a TextField and a TextEditingController into a simple to use package.
class TextFieldNJ extends StatefulWidget {
  const TextFieldNJ(
      {required this.autofillHints,
      super.key,
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
      this.textCapitalization = TextCapitalization.none});
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final TextInputType keyboardType;
  final String? hintText;
  final EdgeInsets? padding;
  final bool Function(String text)? validator;
  final String Function(String text)? errorMessage;
  final String? label;
  final FocusNode? focusNode;
  final List<String> autofillHints;

  final TextCapitalization textCapitalization;

  /// Color of the label
  final Color? labelColor;
  @override
  State<StatefulWidget> createState() => TextFieldNJState();
}

class TextFieldNJState extends State<TextFieldNJ> {
  TextFieldNJState() {
    textController = TextEditingController(text: widget.initialValue ?? '');
  }
  late final TextEditingController textController;
  String errorText = '';

  EdgeInsets defaultPadding = const EdgeInsets.only(bottom: 20);

  bool isValid = true;

  @override
  Widget build(BuildContext context) => Padding(
      padding: widget.padding ?? defaultPadding,
      child: TextField(
          autofillHints: widget.autofillHints,
          controller: textController,
          style: const TextStyle(color: NJColors.errorBackground),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: const TextStyle(color: NJColors.fieldLabel),
            errorText: errorText,
            hintText: widget.hintText,

            //hintStyle: TextStyle(color: Colors.purple)
          ),
          keyboardType: widget.keyboardType,
          onChanged: changeHandler,
          focusNode: widget.focusNode,
          textCapitalization: widget.textCapitalization));

  void changeHandler(String value) {
    widget.onChanged?.call(value);

    setState(() {
      isValid = widget.validator?.call(textController.text) ?? true;
      errorText =
          isValid ? '' : widget.errorMessage?.call(value) ?? 'Error in $value';
    });
  }
}
