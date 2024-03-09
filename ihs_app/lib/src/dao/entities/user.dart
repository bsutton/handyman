import 'package:json_annotation/json_annotation.dart';
import '../../util/strings.dart';
import '../types/email_address.dart';
import '../types/er.dart';
import '../types/phone_number.dart';
import '../types/user_role.dart';
import 'customer.dart';
import 'entity.dart';
import 'voicemail_box.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Entity<User> {
  String apiKey;

  String username;
  String firstname;
  String surname;
  String description;
  String password;

  /// Used to access fire store storage.
  /// The token is created from the firebase temporary user id.
  /// Once allocated it is used in the apps stage 2 sign in
  /// and allows the user to access their data stored in firestore.
  String fireStoreUserToken;

  @EmailAddressConverter()
  EmailAddress emailAddress;

  // The direct in dial no allocated to this user by square phone.
  @PhoneNumberConverter()
  PhoneNumber landline;

  @PhoneNumberConverter()
  PhoneNumber mobilePhone;

  // for staff this is their desktop extension no.
  String extensionNo;

  UserRole userRole;

  // If this user's role is Customer then this will contain the Customer
  // that they are attached to.
  @ERCustomerConverter()
  ER<Customer> owner;

  // Future<Customer> get owner {
  //   return _customer.resolve;
  // }

  @ERConvererVoicemailBox()
  ER<VoicemailBox> voicemailBox;

  /// Do Not Distrub settings

  // If dndUntil is null or in the past then the user is available.
  // If the user isn't available then one of the forwardCalls To
  // settings will be active.
  // @TimeOfDayConverter()
  // TimeOfDay dndUntil;

  // ForwardCallsTo forwardCallsTo = ForwardCallsTo.VOICEMAIL;

  // @ERUserConverter()
  // ER<User> forwardToCollegue;

  // @PhoneNumberConverter()
  // PhoneNumber forwardToExternalNo;

  // Is this user account currently enabled.
  bool enabled = true;

  // used by json decode.
  User({
    this.enabled,
    this.owner,
    this.userRole = UserRole.CustomerStaff,
    this.apiKey,
    this.username,
    this.emailAddress,
    this.description,
    this.firstname,
    this.surname,
    this.mobilePhone,
  });

  User.forInsert() : super.forInsert() {
    userRole = UserRole.CustomerStaff;
  }

  User copyWith({
    bool enabled,
    ER<Customer> owner,
    UserRole userRole,
    String apiKey,
    String username,
    EmailAddress emailAddress,
    String description,
    String firstname,
    String surname,
    PhoneNumber mobilePhone,
  }) {
    final newUser = User(
      enabled: enabled ?? this.enabled,
      owner: owner ?? this.owner,
      userRole: userRole ?? this.userRole,
      apiKey: apiKey ?? this.apiKey,
      username: username ?? this.username,
      emailAddress: emailAddress ?? this.emailAddress,
      description: description ?? this.description,
      firstname: firstname ?? this.firstname,
      surname: surname ?? this.surname,
      mobilePhone: mobilePhone ?? this.mobilePhone,
    );
    newUser.id = id;
    newUser.guid = guid;

    assert(newUser.guid != null);
    return newUser;
  }

  bool get hasApiKey => !Strings.isNullOrEmpty(apiKey);
  bool get isAdministrator => userRole == UserRole.Administrator;

  String get fullname {
    var name = '';
    if (firstname != null) {
      name += firstname;
    }
    if (surname != null) {
      if (name.isNotEmpty) {
        name += ' ';
      }
      name += surname;
    }

    return name;
  }

  PhoneNumber get bestPhoneNumber {
    PhoneNumber bestNo;

    if (mobilePhone != null && mobilePhone.isValid()) {
      bestNo = mobilePhone;
    } else if (landline != null && landline.isValid()) {
      bestNo = landline;
    }

    return bestNo;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class UserValidator {
  static String firstname(String value) {
    if (value == null || value.isEmpty) {
      return 'Must not be empty';
    }
    return null;
  }

  static String surname(String value) {
    if (value == null || value.isEmpty) {
      return 'Must not be empty';
    }
    return null;
  }

  static String mobilePhone(String value) {
    if (!PhoneNumber.isMobile(value)) {
      return 'Must be a valid mobile number';
    }
    return null;
  }
}
