import 'package:flutter/cupertino.dart';

/// A convenience widget that returns a container
/// that has zero height and zero width.
class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
