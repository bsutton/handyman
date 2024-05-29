import 'package:json_annotation/json_annotation.dart';

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
  newOrganisation,
  // A Customer Admin (CA) has invited a new user to join their organisation.
  newUser
  // A Customer Admin has invited an existing user to re-register against
  //their organisation.
  // Required if user gets a new phone or uninstalls squarephone
  ,
  existingUser
  // The user has commence a recovery after getting a new phone
  // or re-installing squarephone.
  ,
  recovery
}

@JsonSerializable()
class UserInvitation extends Entity<UserInvitation> {
  /// json
  UserInvitation(this.owner, this.invitedBy, this.invitee, this.type);

  UserInvitation.existingUser(
      this.owner, this.invitedBy, this.invitee, this.type)
      : super.forInsert() {
    created = DateTime.now();
    expires ??= DateTime.now().add(const Duration(days: 2));
  }

  UserInvitation.newUser(this.owner, this.invitedBy, this.mobile, this.type)
      : super.forInsert() {
    created = DateTime.now();
    expires ??= DateTime.now().add(const Duration(days: 2));
  }

  /// This method is used when:
  /// * We have validated the users mobile
  /// * The user has a know email address
  /// * We are looking to validate their email address.
  UserInvitation.forRecovery(this.mobile) : super.forInsert() {
    type = InvitationType.recovery;

    /// We
    state = InvitationState.mobileValidated;
    created = DateTime.now();
    expires ??= DateTime.now().add(const Duration(hours: 1));
  }

  /// This method is used when:
  ///  * there are no other CAs
  ///  * we have validated their mobile and we have found a user
  ///    for that mobile no.
  ///  * the user doesn't have an email address
  UserInvitation.forRecoveryLastCA(this.mobile) : super.forInsert() {
    type = InvitationType.recovery;

    state = InvitationState.bothValidated;
    created = DateTime.now();
    expires ??= DateTime.now().add(const Duration(hours: 1));
  }

  factory UserInvitation.fromJson(Map<String, dynamic> json) =>
      _$UserInvitationFromJson(json);
  InvitationType type = InvitationType.newUser;

  @ERConverterCustomer()
  late ER<Customer> owner;

  @ERConverterUser()
  late ER<User> invitedBy;

  // The user that is being invited.
  // For a NEW_USER this will be null.
  @ERConverterUser()
  late ER<User> invitee;

  /// The phone number of the person invited.
  @ConverterPhoneNumber()
  late PhoneNumber mobile;

  // The date time that this invite expires
  late DateTime created;

  // The date time that this invite expires
  DateTime? expires;

  // True if this invite has been activated.
  InvitationState state = InvitationState.initial;

  String? ipAddress;

  String? location;

  String? device;

  bool hasExpired() => expires != null && expires!.isAfter(DateTime.now());

  @override
  Map<String, dynamic> toJson() => _$UserInvitationToJson(this);
}


enum InvitationState {
  /// the initial state of the invite when it is first created.
  initial,
  expired,
  notFound,

  /// indicates that the user's mobile has been validated (via firebase)
  /// however this does not mean they are a known user
  mobileValidated,

  /// indicates that the users' email has been validated (by sending
  ///  then a email and them responding to it)
  /// We only allow the email validation process to start if the user 
  /// account has a valid
  /// email address.
  emailValidated,

  /// indicates that both the user's email and mobile have been validated as per
  /// the above conditions
  /// or
  /// special circumstances exists and only one validation method is required
  /// in which case we will progress directly to this state.
  /// This can occur if the user is the last CA.
  bothValidated,

  activated,

  /// an exception was thrown processing the invitation.
  exception
}
