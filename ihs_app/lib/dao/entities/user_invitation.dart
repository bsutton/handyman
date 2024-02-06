import 'package:json_annotation/json_annotation.dart';

import '../../registration_wizard/invitation_state.dart';
import '../types/er.dart';
import '../types/phone_number.dart';
import 'customer.dart';
import 'entity.dart';
import 'user.dart';

part 'user_invitation.g.dart';

/// these enums must match the java enum InvitationType
enum InvitationType {
  /// A new organisation is being setup. Technically this isn't an invitation
  /// but we create on incase the app restarts during registration.
  NEW_ORGANISATION,
  // A Customer Admin (CA) has invited a new user to join their organisation.
  NEW_USER
  // A Customer Admin has invited an existing user to re-register agains their organisation.
  // Required if user gets a new phone or uninstalls squarephone
  ,
  EXISTING_USER
  // The user has commence a recovery after getting a new phone or re-installing squarephone.
  ,
  RECOVERY
}

@JsonSerializable()
class UserInvitation extends Entity<UserInvitation> {
  InvitationType type;

  @ERCustomerConverter()
  ER<Customer> owner;

  @ERUserConverter()
  ER<User> invitedBy;

  // The user that is being invited.
  // For a NEW_USER this will be null.
  @ERUserConverter()
  ER<User> invitee;

  /// The phone number of the person invited.
  @PhoneNumberConverter()
  PhoneNumber mobile;

  // The date time that this invite expires
  DateTime created;

  // The date time that this invite expires
  DateTime expires;

  // True if this invite has been activated.
  InvitationState state = InvitationState.INITIAL;

  String ipAddress;

  String location;

  String device;

  /// json
  UserInvitation(this.owner, this.invitedBy, this.invitee, this.type);

  UserInvitation.existingUser(
      this.owner, this.invitedBy, this.invitee, this.type)
      : super.forInsert() {
    created = DateTime.now();
    expires ??= DateTime.now().add(Duration(days: 2));
  }

  UserInvitation.newUser(this.owner, this.invitedBy, this.mobile, this.type)
      : super.forInsert() {
    created = DateTime.now();
    expires ??= DateTime.now().add(Duration(days: 2));
  }

  /// This method is used when:
  /// * We have validated the users mobile
  /// * The user has a know email address
  /// * We are looking to validate their email address.
  UserInvitation.forRecovery(this.mobile) : super.forInsert() {
    type = InvitationType.RECOVERY;

    /// We
    state = InvitationState.MOBILE_VALIDATED;
    created = DateTime.now();
    expires ??= DateTime.now().add(Duration(hours: 1));
  }

  /// This method is used when:
  ///  * there are no other CAs
  ///  * we have validated their mobile and we have found a user
  ///    for that mobile no.
  ///  * the user doesn't have an email address
  UserInvitation.forRecoveryLastCA(this.mobile) : super.forInsert() {
    type = InvitationType.RECOVERY;

    state = InvitationState.BOTH_VALIDATED;
    created = DateTime.now();
    expires ??= DateTime.now().add(Duration(hours: 1));
  }

  bool hasExpired() {
    return expires.isAfter(DateTime.now());
  }

  factory UserInvitation.fromJson(Map<String, dynamic> json) =>
      _$UserInvitationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserInvitationToJson(this);
}
