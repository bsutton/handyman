import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

import '../../../../../app/app_scaffold.dart';
import '../../../../../app/router.dart';
import '../../../../../app/square_phone_app.dart';
import '../../../../../dao/entities/user_invitation.dart';
import '../../../../../dao/repository/repos.dart';
import '../../../../../dao/repository/user_repository.dart';
import '../../../../../dao/types/er.dart';
import '../../../../../dao/types/phone_number.dart';
import '../../../../../util/quick_snack.dart';
import '../../../../../widgets/blocking_ui.dart';
import '../../../../../widgets/theme/nj_button.dart';
import '../../../../../widgets/theme/nj_text_themes.dart';
import '../../../dashboard_page.dart';
import '../../dashboard/office_page_thumb_menu.dart';

class UserInvitePage extends StatefulWidget {
  const UserInvitePage({super.key});

  static const RouteName routeName = RouteName('/userinvitepage');
  @override
  UserInvitePageState createState() => UserInvitePageState();
}

enum _SentState { sent, sending, notsent }

class UserInvitePageState extends State<UserInvitePage> {
  InvitationType invitationType = InvitationType.newUser;
  final _formKey = GlobalKey<FormState>();
  _SentState _sent = _SentState.notsent;

  ///
  final TextEditingController mobileFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) => AppScaffold(
        builder: (context) => DashboardPage(
            title: 'Invite a Colleague',
            currentRouteName: UserInvitePage.routeName,
            builder: (context) => buildForm(),
            thumbMenu: OfficePageThumbMenu()),
      );

  Widget buildForm() => SingleChildScrollView(
        child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RadioListTile<InvitationType>(
                title: NJTextLabel(
                  'New Colleague',
                ),
                subtitle:
                    Text('Invite a new person to use ${SquarePhoneApp.name}.'),
                value: InvitationType.newUser,
                groupValue: invitationType,
                onChanged: (value) {
                  setState(() {
                    invitationType = value ?? InvitationType.newUser;
                  });
                },
              ),
              RadioListTile<InvitationType>(
                title: NJTextLabel('Existing Colleague'),
                subtitle: Text(
                  'Invite an existing ${SquarePhoneApp.name} user that may have lost their phone or had to re-install ${SquarePhoneApp.name}.',
                ),
                value: InvitationType.existingUser,
                groupValue: invitationType,
                onChanged: (value) {
                  setState(() {
                    invitationType = value ?? InvitationType.existingUser;
                  });
                },
              ),
              const SizedBox(height: 20),
              NJTextLabel("Colleague's Mobile No."),
              TextFormField(
                  controller: mobileFieldController,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumberNational],
                  validator: (phoneNumber) => PhoneNumber.formFieldValidate(
                      phoneNumber ?? '',
                      allowEmpty: false),
                  decoration: const InputDecoration(
                      hintText: "Enter colleague's mobile no.")),
              Center(
                  child:
                      // Send Invite button
                      NJButtonPrimary(
                          enabled: _sent == _SentState.notsent,
                          label: 'Send Invite',
                          onPressed: sendInvite)),
              const SizedBox(height: 20),
              NJTextBody(
                  '''A text message will be sent to your Colleague inviting them to install ${SquarePhoneApp.name} and join your organisation.'''),
              NJUTextAncillary('''The invitation expires after two days.'''),
            ])),
      );

  Future<void> sendInvite() async {
    if (_formKey.currentState!.validate()) {
      final canSend = await canSendSMS();
      if (!canSend) {
        if (mounted) {
          await QuickSnack().error(context,
              'You cannot send text messages from this device. Check that you have a connection.');
        }
      } else {
        final mobile = mobileFieldController.text;
        final loggedInUser = await UserRepository().loggedInUser;
        final name = loggedInUser.fullname;
        const downloadUrl = SquarePhoneApp.invitedURL;
        final message =
            '$name has invited you to install ${SquarePhoneApp.name}. $downloadUrl';

        setState(() {
          _sent = _SentState.sending;
        });

        await BlockingUI().run<void>(() async {
          if (invitationType == InvitationType.newUser) {
            await Repos().inviteUser.insert(UserInvitation.newUser(
                loggedInUser.owner!,
                ER(loggedInUser),
                PhoneNumber(mobile),
                InvitationType.newUser));
            await doSendSMS(recipients: [mobile], message: message);
          } else {
            final invitee = await Repos().user.getByMobile(PhoneNumber(mobile));
            await Repos().inviteUser.insert(UserInvitation.existingUser(
                loggedInUser.owner!,
                ER(loggedInUser),
                ER(invitee!),
                InvitationType.existingUser));

            await doSendSMS(recipients: [mobile], message: message);
            return;
          }
        });
      }
    }
  }

  Future<void> doSendSMS(
      {required List<String> recipients, required String message}) async {
    await sendSMS(message: message, recipients: recipients).catchError(onError);
    if (mounted) {
      await QuickSnack().info(context, 'The invitation has been sent.',
          duration: const Duration(seconds: 20));
    }
    setState(() {
      _sent = _SentState.sent;
    });
  }

  Future<String> onError(Object error, StackTrace st) {
    QuickSnack().error(context, 'The send failed: $error');
    setState(() {
      _sent = _SentState.notsent;
    });

    return Future.value('The send failed: $error');
  }
}
