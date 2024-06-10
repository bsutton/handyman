import 'package:flutter/material.dart';

class LabeledContainer extends StatelessWidget {
  const LabeledContainer({
    required this.labelText,
    required this.child,
    super.key,
  });
  final String labelText;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none, // Allow overflow for the Positioned widget
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 20), // Adjust to prevent clipping
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
          Positioned(
            top: 8,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                labelText,
                style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodyLarge?.color ??
                        Colors.black,
                    backgroundColor: Theme.of(context).cardColor),
              ),
            ),
          ),
        ],
      );
}
