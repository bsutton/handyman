import 'package:flutter/foundation.dart';
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
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(StringProperty('heading', heading))
    ..add(ColorProperty('textColor', textColor))
    ..add(ColorProperty('backgroundColor', backgroundColor));
  }
}
