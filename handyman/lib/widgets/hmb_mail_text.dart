import 'package:flutter/material.dart';
import 'package:strings/strings.dart';

import 'mail_to_icon.dart';

class HBMMailText extends StatelessWidget {
  const HBMMailText({required this.label, required this.email, super.key});
  final String label;
  final String? email;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (Strings.isNotBlank(email)) Text('$label ${email ?? ''}'),
          if (Strings.isNotBlank(email)) MailToIcon(email)
        ],
      );
}
