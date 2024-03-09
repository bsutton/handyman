import 'package:json_annotation/json_annotation.dart';
import '../../util/local_date.dart';
import '../types/phone_number.dart';
import 'entity.dart';

part 'mobile_registration_reminder.g.dart';

@JsonSerializable()
class MobileRegistrationReminder extends Entity<MobileRegistrationReminder> {
  String progressUUID;

  @PhoneNumberConverter()
  PhoneNumber mobile;

  @LocalDateConverter()
  DateTime registrationDateTime = DateTime.now();

  @LocalDateConverter()
  DateTime firstReminder;

  // for json.
  MobileRegistrationReminder();

  MobileRegistrationReminder.forInsert(this.firstReminder) : super.forInsert();

  factory MobileRegistrationReminder.fromJson(Map<String, dynamic> json) =>
      _$MobileRegistrationReminderFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MobileRegistrationReminderToJson(this);
}
