import 'package:flutter/material.dart';
import 'theme/nj_text_themes.dart';
import 'theme/nj_theme.dart';

class DialogHeading extends StatelessWidget {
  final String heading;
  final Color backgroundColor;
  final Color textColor;

  DialogHeading(this.heading,
      {this.backgroundColor = NJColors.headingBackground, this.textColor = NJColors.textPrimary});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: NJTextHeadline(heading.toUpperCase(), color: textColor),
        ),
      ),
    );
  }
}
