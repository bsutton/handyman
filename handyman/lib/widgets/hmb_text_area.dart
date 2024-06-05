import 'package:flutter/material.dart';

class HMBTextArea extends StatelessWidget {
  const HMBTextArea({
    required TextEditingController descriptionController,
    required FocusNode nameFocusNode,
    required this.labelText,
    super.key,
  })  : _descriptionController = descriptionController,
        _nameFocusNode = nameFocusNode;

  final TextEditingController _descriptionController;
  final FocusNode _nameFocusNode;
  final String labelText;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 200,
        child: TextFormField(
          controller: _descriptionController,
          focusNode: _nameFocusNode,
          decoration: InputDecoration(labelText: labelText),
        ),
      );
}
