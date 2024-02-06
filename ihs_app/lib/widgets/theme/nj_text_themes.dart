import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'nj_theme.dart';

///
/// Use this style on any page that has a full width heading at the top of the page.
///
class NJTextPageHeading extends StatelessWidget {
  NJTextPageHeading(String text, {super.key, this.color = NJColors.textPrimary})
      : text = text.toUpperCase();
  final String text;
  final Color color;
  static const fontSize = 30.0;

  @override
  Widget build(BuildContext context) => FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: fontSize, fontWeight: FontWeight.w500)));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(ColorProperty('color', color));
  }
}

class NJTextHeadline extends StatelessWidget {
  const NJTextHeadline(this.text,
      {super.key, this.color = NJColors.textPrimary});
  final String text;
  final Color color;
  static const fontSize = 30.0;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: fontSize, fontWeight: FontWeight.w500)),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(ColorProperty('color', color));
  }
}

class NJTextHeadline2 extends StatelessWidget {
  const NJTextHeadline2(this.text,
      {super.key, this.color = NJColors.textPrimary});
  final String text;
  final Color color;
  static const fontSize = 26.0;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: fontSize, fontWeight: FontWeight.w500)),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(ColorProperty('color', color));
  }
}

class NJTextSubheading extends StatelessWidget {
  NJTextSubheading(this.text, {super.key, this.color = NJColors.textPrimary})
      : style = TextStyle(fontSize: fontSize, color: color);
  final String text;
  final Color color;
  static const fontSize = 22.0;

  final TextStyle style;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(text, style: style),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<TextStyle>('style', style));
  }
}

/// Use this for a section heading within the body of a document
/// This is normally used as a heading for a paragraph which
/// uses the TextNJBody style.
class NJTextSectionHeading extends StatelessWidget {
  NJTextSectionHeading(this.text,
      {super.key, this.color = NJColors.textPrimary})
      : style = TextStyle(
            fontSize: fontSize, color: color, fontWeight: FontWeight.bold);
  final String text;
  final Color color;
  static const fontSize = 18.0;

  final TextStyle style;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(10), child: Text(text, style: style));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<TextStyle>('style', style));
  }
}

///
/// Used for text and  paragraphs of text that should use the
///  standard font/styling for the body of a document.
class NJTextBody extends StatelessWidget {
  NJTextBody(this.text, {super.key, this.color = NJColors.textPrimary})
      : _style = style.copyWith(color: color);
  static const fontSize = 16.0;
  static const TextStyle style = TextStyle(fontSize: fontSize);

  final TextStyle _style;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(text, style: _style),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(ColorProperty('color', color));
  }
}

/// Use for text in a body section that needs to be bold.
class NJTextBodyBold extends StatelessWidget {
  NJTextBodyBold(this.text, {super.key, this.color = NJColors.textPrimary})
      : style = TextStyle(
            color: color, fontSize: fontSize, fontWeight: FontWeight.bold);
  final String text;
  final Color color;
  final TextStyle style;
  static const fontSize = 16.0;

  @override
  Widget build(BuildContext context) => Text(text, style: style);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<TextStyle>('style', style));
  }
}

///
/// Use this style when you are looking to display
/// some ancillary information that isn't that important.
/// Ancillary text will be displayed in a lighter font color
class NJUTextAncillary extends StatelessWidget {
  NJUTextAncillary(this.text, {super.key, this.color = Colors.grey})
      : style = TextStyle(color: color, fontSize: fontSize);
  static const fontSize = 16.0;
  final String text;
  final Color color;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(8), child: Text(text, style: style));
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<TextStyle>('style', style));
  }
}

enum Position { START, END }

class NJTextIcon extends StatelessWidget {
  const NJTextIcon(this.text, this.icon,
      {required this.color,
      super.key,
      this.position = Position.START,
      this.iconColor});
  static const fontSize = NJTextListItem.fontSize;
  final String text;
  final IconData icon;
  final Position position;
  final Color color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    if (position == Position.START) {
      return Row(children: [
        Icon(icon, color: iconColor),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: NJTextListItem(text, color: color),
        )
      ]);
    } else {
      return Row(children: [
        Padding(
            padding: const EdgeInsets.only(right: 5),
            child: NJTextListItem(text, color: color)),
        Icon(icon, color: iconColor)
      ]);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(EnumProperty<Position>('position', position));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('iconColor', iconColor));
  }
}
