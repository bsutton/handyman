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
                color: color,
                fontSize: fontSize,
                fontWeight: FontWeight.w500)));
}

class NJTextHeadline extends StatelessWidget {

  const NJTextHeadline(this.text, {super.key, this.color = NJColors.textPrimary});
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
}

class NJTextHeadline2 extends StatelessWidget {

  const NJTextHeadline2(this.text, {super.key, this.color = NJColors.textPrimary});
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
}

/// Use this for a section heading within the body of a document
/// This is normally used as a heading for a paragraph which
/// uses the TextNJBody style.
class NJTextSectionHeading extends StatelessWidget {

  NJTextSectionHeading(this.text, {super.key, this.color = NJColors.textPrimary})
      : style = TextStyle(
            fontSize: fontSize, color: color, fontWeight: FontWeight.bold);
  final String text;
  final Color color;
  static const fontSize = 18.0;

  final TextStyle style;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10), child: Text(text, style: style));
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
}

///
/// Used in the body of a document where you need to
/// highlight the text. This is essentially a bolded TextNJBody
///
class NJTextNotice extends StatelessWidget {

  const NJTextNotice(this.text, {super.key});
  static const fontSize = 14.0;
  final String text;
  static const TextStyle noticeStyle =
      TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) => Text(text, style: noticeStyle);
}

///
/// Used when you need to display text indicating an error.
///
class NJTextError extends StatelessWidget {

  const NJTextError(this.text, {super.key});
  static const fontSize = 14.0;
  final String text;
  static const TextStyle noticeStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: NJColors.errorText,
      backgroundColor: NJColors.errorBackground);

  @override
  Widget build(BuildContext context) => Text(text, style: noticeStyle);
}

///
/// Text style used by buttons such as ButtonPrimary/ButtonSecondary
///
class NJTextButton extends StatelessWidget {

  NJTextButton(this.text, {super.key, this.color = NJColors.textPrimary})
      : style = TextStyle(color: color, fontSize: fontSize);
  static const fontSize = 16.0;
  final String text;
  final Color color;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(), style: style);
}

/// Use for Form Field labels.
class NJTextLabel extends StatelessWidget {

  NJTextLabel(this.text, {super.key, this.color = NJColors.textPrimary})
      : style = TextStyle(color: color, fontSize: fontSize);
  static const fontSize = 16.0;
  final String text;
  final Color color;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Text(text, style: style);
}

///
/// Use this for text that is displayed in the likes of a ListView
///
class NJTextListItem extends StatelessWidget {

  const NJTextListItem(this.text, {super.key, this.color = NJColors.listCardText});
  final String text;
  final Color? color;
  static const fontSize = 16.0;
  static const TextStyle style = TextStyle(fontSize: fontSize);

  @override
  Widget build(BuildContext context) => Text(text, style: style.copyWith(color: color));
}

///
/// Use this for text that is displayed in the likes of a ListView
///
class NJTextListItemBold extends StatelessWidget {

  const NJTextListItemBold(this.text, {super.key, this.color = NJColors.listCardText});
  static const fontSize = 16.0;
  final String text;
  final Color color;
  static const TextStyle style =
      TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) => Text(text, style: style.copyWith(color: color));
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
}

///
/// Used for the text within chips.
class NJTextChip extends StatelessWidget {

  NJTextChip(this.text, {super.key, this.color = NJColors.chipTextColor})
      : _style = style.copyWith(color: color);
  static const fontSize = 15.0;
  static const TextStyle style = TextStyle(fontSize: fontSize);

  final TextStyle _style;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(text, style: _style);
}

enum Position { start, end }

class NJTextIcon extends StatelessWidget {

  const NJTextIcon(this.text, this.icon,
      {super.key, this.position = Position.start, this.iconColor, this.color});
  static const fontSize = NJTextListItem.fontSize;
  final String text;
  final IconData icon;
  final Position position;
  final Color? color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    if (position == Position.start) {
      return Row(children: [
        Icon(icon, color: iconColor),
        Padding(
            padding: const EdgeInsets.only(left: 5),
            child: NJTextListItem(text, color: color))
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
}
