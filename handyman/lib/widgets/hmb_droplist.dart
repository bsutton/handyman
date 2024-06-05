// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class HMBDroplist<T> extends StatelessWidget {
  const HMBDroplist({
    required this.labelText,
    required this.initialValue,
    required this.items,
    required this.onChanged,
    this.leadingSpace = true,
    super.key,
    this.format,
  });

  final T initialValue;
  final String labelText;
  final List<T> items;

  final bool leadingSpace;

  final void Function(T? value) onChanged;

  final String Function(T value)? format;

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
              items: _getDropdownItems(items),
              onChanged: onChanged),
        ],
      );

  List<DropdownMenuItem<T>> _getDropdownItems(List<T> values) => values
      .map((type) => DropdownMenuItem<T>(
            value: type,
            child: Text(format != null ? format!(type) : type.toString()),
          ))
      .toList();
}
