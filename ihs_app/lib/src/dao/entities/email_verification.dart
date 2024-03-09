import 'package:json_annotation/json_annotation.dart';

import 'entity.dart';

part 'email_verification.g.dart';

enum EmailVerificationType { RECOVERY, INVITE }

@JsonSerializable()
class EmailVerification extends Entity<EmailVerification> {
  EmailVerificationType type;

  GUID invitationGUID;

  // The date time that this invite expires
  DateTime created;

  /// If type is INVITE we will have their email address
  /// but not their GUID
  String emailAddress;

  // The date time that this invite expires
  DateTime expires;

  // True if this invite has been activated.
  bool verified = false;

  /// IP address of the device that requested the verification.
  String ipAddress;

  String location;

  /// user agent/device.
  String device;

  /// used for json
  EmailVerification();

  EmailVerification.forInvitation(this.invitationGUID, this.emailAddress)
      : type = EmailVerificationType.INVITE,
        super.forInsert() {
    created = DateTime.now();
    expires ??= DateTime.now().add(Duration(days: 2));
  }

  EmailVerification.forRecovery(this.invitationGUID)
      : type = EmailVerificationType.RECOVERY,
        super.forInsert() {
    created = DateTime.now();
    expires ??= DateTime.now().add(Duration(days: 2));
  }

  bool hasExpired() {
    return expires.isAfter(DateTime.now());
  }

  factory EmailVerification.fromJson(Map<String, dynamic> json) =>
      _$EmailVerificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EmailVerificationToJson(this);
}
