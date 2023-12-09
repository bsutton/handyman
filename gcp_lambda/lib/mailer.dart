// ignore_for_file: avoid_catches_without_on_clauses

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:settings_yaml/settings_yaml.dart';

Future<void> sendEmail(
    {required String from,
    required String to,
    required String subject,
    required String body}) async {
  final settings = SettingsYaml.load(pathToSettings: 'config.yaml');

  final username = settings.asString('app_username');
  final password = settings.asString('app_password');
  final smtpServer = gmail(username, password);

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
    print('email sent $sendReport');
  } catch (e) {
    print('Error: $e');
  }
}
