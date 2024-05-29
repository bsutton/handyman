import 'package:json_annotation/json_annotation.dart';

import 'entity.dart';

part 'email_verification.g.dart';

enum EmailVerificationType { recovery, invite }

@JsonSerializable()
class EmailVerification extends Entity<EmailVerification> {
  /// used for json
  EmailVerification();

  EmailVerification.forInvitation(
      this.invitationGUID, this.emailAddress, DateTime? expires)
      : type = EmailVerificationType.invite,
        super.forInsert() {
    created = DateTime.now();
    this.expires = expires ?? DateTime.now().add(const Duration(days: 2));
  }

  EmailVerification.forRecovery(this.invitationGUID, DateTime? expires)
      : type = EmailVerificationType.recovery,
        super.forInsert() {
    created = DateTime.now();
    this.expires = expires ?? DateTime.now().add(const Duration(days: 2));
  }

  factory EmailVerification.fromJson(Map<String, dynamic> json) =>
      _$EmailVerificationFromJson(json);
  late EmailVerificationType type;

  late GUID invitationGUID;

  // The date time that this invite expires
  late DateTime created;

  /// If type is INVITE we will have their email address
  /// but not their GUID
  late String emailAddress;

  // The date time that this invite expires
  late DateTime expires;

  // True if this invite has been activated.
  late bool verified = false;

  /// IP address of the device that requested the verification.
  String? ipAddress;

  String? location;

  /// user agent/device.
  String? device;

  bool hasExpired() => expires.isAfter(DateTime.now());

  @override
  Map<String, dynamic> toJson() => _$EmailVerificationToJson(this);
}
