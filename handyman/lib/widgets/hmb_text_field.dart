import 'package:flutter/material.dart';

class HMBTextField extends StatelessWidget {
  const HMBTextField(
      {required this.controller,
      required this.labelText,
      this.required = false,
      this.validator,
      this.focusNode,
      super.key,
      this.autofocus = false,
      this.leadingSpace = true});

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String labelText;
  final String? Function(String? value)? validator;
  final bool autofocus;
  final bool required;
  final bool leadingSpace;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          if (leadingSpace) const SizedBox(height: 16),
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            autofocus: autofocus,
            decoration: InputDecoration(
              labelText: labelText,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a $labelText';
              }
              return validator?.call(value);
            },
          ),
        ],
      );
}
