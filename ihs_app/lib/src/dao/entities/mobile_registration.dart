import 'package:json_annotation/json_annotation.dart';
import '../../util/local_date.dart';
import '../types/er.dart';
import '../types/guid.dart';
import '../types/phone_number.dart';
import 'entity.dart';
import 'region.dart';

part 'mobile_registration.g.dart';

enum MobileRegistrationStatus {
  STARTED // a new regisration which has been started.
  ,
  REMINDER_DUE // the user abandoned the registration and has requested a reminder
  ,
  ABANDONED // the user abnadoned the registration but did not request a reminder.
  ,
  COMPLETE // the user completed the registration (transitioned through the done page)
  ,
  SUBSCRIBED // the user has signed up for a full subscription
}

@JsonSerializable()
class MobileRegistration extends Entity<MobileRegistration> {
  String firstname = '';
  String surname = '';

  @ERRegionConverter()
  ER<Region> region;

  @PhoneNumberConverter()
  PhoneNumber mobile;

  MobileRegistrationStatus status = MobileRegistrationStatus.STARTED;

  // The date the registration was completed by the user.
  LocalDate _registrationStartDate;

  @LocalDateConverter()
  LocalDate registrationExpiryDate;

  @PhoneNumberConverter()
  PhoneNumber trialBusinessNo;

  MobileRegistration();

  MobileRegistration.forInsert() : super.forInsert();

  MobileRegistration.empty() {
    firstname = '';
    surname = '';
  }

  set registrationStartDate(LocalDate startDate) {
    // some extra null checks to handle json decoding.
    _registrationStartDate = startDate ?? LocalDate.today();
    registrationExpiryDate =
        registrationExpiryDate ?? _registrationStartDate.addDays(14);
  }

  @LocalDateConverter()
  LocalDate get registrationStartDate => _registrationStartDate;

  bool get hasState => region != null;

  bool get hasTrialNo => trialBusinessNo != null && trialBusinessNo.isValid();

  factory MobileRegistration.fromJson(Map<String, dynamic> json) =>
      _$MobileRegistrationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MobileRegistrationToJson(this);
}
