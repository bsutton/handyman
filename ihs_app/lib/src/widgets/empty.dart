import 'package:flutter/cupertino.dart';

/// A convenience widget that returns a container
/// that has zero height and zero width.
class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 0, height: 0);
  }
}
