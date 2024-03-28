import 'package:flutter/material.dart';

import 'theme/nj_text_themes.dart';
import 'theme/nj_theme.dart';

class DialogHeading extends StatelessWidget {
  const DialogHeading(this.heading,
      {super.key,
      this.backgroundColor = NJColors.headingBackground,
      this.textColor = NJColors.textPrimary});
  final String heading;
  final Color? backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) => Container(
        color: backgroundColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: NJTextHeadline(heading.toUpperCase(), color: textColor),
          ),
        ),
      );
}
