import 'package:flutter/material.dart';

class HMBTextArea extends StatelessWidget {
  const HMBTextArea(
      {required this.controller,
      required this.labelText,
      this.maxLines = 6,
      this.focusNode,
      super.key});

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String labelText;
  final int maxLines;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 200,
        child: TextFormField(
          maxLines: maxLines,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(labelText: labelText,
            border: const OutlineInputBorder(),
          ),
        ),
      );
}
