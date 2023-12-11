// import 'dart:convert';
// import 'dart:io' as io;

// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/gmail/v1.dart';
// import 'package:googleapis_auth/auth_io.dart';

// // Future<AutoRefreshingAuthClient> authenticate() async {
// //   const clientId = 'YOUR_CLIENT_ID';
// //   const clientSecret = 'YOUR_CLIENT_SECRET';
// //   final scopes = [GmailApi.gmailSendScope];

// //   final credentials = await clientViaUserConsent(
// //     ClientId.fromJson({
// //       'client_id': clientId,
// //       'client_secret': clientSecret,
// //       'scopes': scopes,
// //     })
// //     // identifier: 'YOUR_IDENTIFIER',
// //     // client: io.HttpClient(),
// //   );

// //   return credentials;
// // }

// // Future<GmailApi> getGmailClient() async {
// //   final credentials = await authenticate();
// //   return GmailApi(credentials);
// // }



// Future<void> sendEmail(String to, String subject, String body) async {
//   final gmailApi = await getGmailClient();

//   final mimeMessage = Message()
//     ..raw = base64Url.encode(utf8.encode(_createEmail(to, subject, body)));

//   await gmailApi.users.messages.send(mimeMessage, 'me');
// }

// String _createEmail(String to, String subject, String body) {
//   final lines = [
//     'To: $to',
//     'Subject: $subject',
//     'Content-Type: text/html; charset=utf-8',
//     '',
//     body
//   ];

//   return lines.join('\r\n');
// }

// void main() async {
//   const to = 'recipient@example.com';
//   const subject = 'Test Email';
//   const body = '<p>This is a test email sent from Dart.</p>';

//   await sendEmail(to, subject, body);
//   print('Email sent successfully!');
// }
