import 'package:flutter/material.dart';

class HMBTextField extends StatelessWidget {
  const HMBTextField(
      {required this.controller,
      required this.labelText,
      this.required = false,
      this.validator,
      this.focusNode,
      this.onChanged,
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
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          if (leadingSpace) const SizedBox(height: 16),
          TextFormField(
            onChanged: onChanged?.call,
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
