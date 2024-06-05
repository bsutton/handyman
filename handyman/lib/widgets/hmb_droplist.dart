// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class HMBDroplist<T extends Enum> extends StatelessWidget {
  const HMBDroplist({
    required this.labelText,
    required this.initialValue,
    required this.items,
    required this.onChange,
    this.leadingSpace = true,
    super.key,
  });

  final T initialValue;
  final String labelText;
  final List<DropdownMenuItem<T>>? items;
  final bool leadingSpace;

  final void Function(T? value) onChange;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          if (leadingSpace) const SizedBox(height: 16),
          DropdownButtonFormField<T>(
              value: initialValue,
              decoration: InputDecoration(
                labelText: labelText,
                border: const OutlineInputBorder(),
              ),
              items: items,
              onChanged: onChange),
        ],
      );
}
