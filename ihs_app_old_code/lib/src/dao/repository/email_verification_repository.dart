import '../entities/email_verification.dart';
import '../types/phone_number.dart';
import 'repository.dart';

/// Used to initiate and track email verifications.
class EmailVerificationRepository extends Repository<EmailVerification> {
  EmailVerificationRepository() : super(const Duration(minutes: 5));

  @override
  EmailVerification fromJson(Map<String, dynamic> json) =>
      EmailVerification.fromJson(json);

  /// Gets the current email verification for the given mobile no.
  Future<EmailVerification?> getByMobile(PhoneNumber mobileNumber) async =>
      getFirst('mobile', mobileNumber.toE164());

  // Future<bool> sendRecoveryEmailVerification(
  //   BuildContext context,
  //   EmailVerification emailVerification,
  //   String toEmailAddress,
  // ) async {
  //   return _sendEmailVerification(
  //       context: context,
  //       emailVerification: emailVerification,
  //       toEmailAddress: toEmailAddress,
  //       emailVerificationUrl: emailVerification.getRecoveryVerificationUrl(),
  //       emailTroubleShootUrl: SquarePhoneApp.recoveryEmailTroubleShootUrl,
  //       templateAssetPath: 'assets/html/email_templates/recovery.html');
  // }

  // Future<bool> sendInviteEmailVerification({
  //   BuildContext context,
  //   EmailVerification emailVerification,
  //   String toEmailAddress,
  // }) async {
  //   return _sendEmailVerification(
  //       context: context,
  //       emailVerification: emailVerification,
  //       toEmailAddress: toEmailAddress,
  //       emailVerificationUrl:
  //           emailVerification.getAcceptInviteVerificationUrl(),
  //       emailTroubleShootUrl: SquarePhoneApp
  // .acceptInviteEmailTroubleShootUrl,
  //       templateAssetPath: 'assets/html/email_templates/accept_invite.html');
  // }

  // /// The [templateAssetPath] is the path to the HTML template which is normally located in:
  // /// assets/html/email_templates.
  // Future<bool> _sendEmailVerification({
  //   BuildContext context,
  //   EmailVerification emailVerification,
  // }) async {
  //   await UnAuthedActionRepository().createEmailVerficiation(
  //       context, emailVerification, RetryData.defaultRetry);

  //   return response.success;
  // }
}
