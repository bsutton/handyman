import 'package:flutter/material.dart';

import 'mail_to_icon.dart';

class HMBEmailField extends StatelessWidget {
  const HMBEmailField(
      {required this.labelText,
      required this.controller,
      this.required = false,
      super.key,
      this.validator});

  final TextEditingController controller;
  final String? Function(String? value)? validator;

  final String labelText;
  final bool required;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: MailToIcon(controller.text),
        ),
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'Please enter the email address';
          }

          if (value != null) {
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
          }
          return null;
        },
      );
}