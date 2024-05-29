import '../../../util/customer_account_status.dart';
import '../../../util/enum_helper.dart';
import '../../entities/user_invitation.dart';
import '../../transaction/transaction.dart';

enum UserStatus { notFound, enabled, disabled }

class UserStatusDetails {
  UserStatusDetails();

  UserStatusDetails.fromJson(ActionResponse response) {
    success = response.wasSuccessful();
    userStatus = EnumHelper.getEnum(
        response.data!['userStatus'] as String, UserStatus.values);
    customerAccountStatus = EnumHelper.getEnum(
        response.data!['customerAccountStatus'] as String,
        CustomerAccountStatus.values);
    hasValidatedInvitation = response.data!['hasValidatedInvitation'] as bool;
    hasEmail = response.data!['hasEmail'] as bool;
    hasOtherCustomerAdmins = response.data!['hasOtherCustomerAdmins'] as bool;

    userInvitation = UserInvitation.fromJson(response.singleEntity!);

    failureCause = response.userExceptionMessage;
  }
  late bool success;
  late UserStatus userStatus;
  late CustomerAccountStatus customerAccountStatus;
  late bool hasEmail;

  /// true if the invitee's mobile has been validated.
  late bool hasValidatedInvitation;
  late UserInvitation userInvitation;

  String? failureCause;

  /// if true then the organisation has active users that
  /// have a Role of CustomerAdministrator other than
  /// this user.
  bool hasOtherCustomerAdmins = false;

  /// There is an existing invitation and it hasn't expired.
  bool get hasViableInvitation =>
      userInvitation.guid!.isValid && !userInvitation.hasExpired();
}
