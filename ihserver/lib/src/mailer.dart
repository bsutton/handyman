// ignore_for_file: avoid_catches_without_on_clauses

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import 'config.dart';
import 'logger.dart';

Future<bool> sendEmail(
    {required String from,
    required String to,
    required String subject,
    required String body}) async {
  final config = Config();
  final smtpServer = gmail(config.username, config.password);

  // configure the from
  final message = Message()
    ..from = Address(
      from,
      'Ivanhoe Handyman Services',
    )
    ..recipients.add(to)
    ..subject = subject
    ..html = body;

  try {
    final sendReport = await send(message, smtpServer);
    qlog('email sent $sendReport');
    return true;
  } on SmtpMessageValidationException catch (e) {
    qlogerr('Error: $e');
    for (final problem in e.problems) {
      qlogerr('${problem.code} ${problem.msg}');
    }
    return false;
  } catch (e) {
    qlog('Error: $e');
    return false;
  }
}
