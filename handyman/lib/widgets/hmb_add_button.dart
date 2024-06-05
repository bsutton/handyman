import 'package:flutter/material.dart';

/// Displays the primary site of a parent
/// and allows the user to select/update the primary site.
class HMBAddButton extends StatelessWidget {
  const HMBAddButton(
      {required this.onPressed, required this.enabled, super.key});
  final Future<void> Function() onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) => IconButton(
      icon: const Icon(Icons.add), onPressed: enabled ? onPressed : null);
}
