import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:mailto/mailto.dart';
import 'package:strings/strings.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MailToIcon extends StatelessWidget {
  const MailToIcon(this.email, {super.key});
  final String? email;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.email),
        onPressed: () async =>
            Strings.isEmpty(email) ? null : _sendEmail(context, email!),
        color: Strings.isEmpty(email) ? Colors.grey : Colors.blue,
      );

  Future<void> _sendEmail(BuildContext context, String email) async {
    if (!EmailValidator.validate(email)) {
      FToast
          // .init(context)
          .toast(context,
              msg: "Invalid email address '$email'", color: Colors.red);
    } else {
      final mailtoLink = Mailto(
        to: [email],
      );
      await launchUrlString(mailtoLink.toString());
    }
  }
}
