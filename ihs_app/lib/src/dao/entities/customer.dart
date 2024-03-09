import 'package:json_annotation/json_annotation.dart';
import '../../util/local_date.dart';
import '../types/er.dart';
import '../types/guid.dart';
import 'did_forward.dart';
import 'entity.dart';
import 'office_holidays.dart';
import 'region.dart';
import 'user.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer extends Entity<Customer> {
  @ERUserConverter()
  ER<User> primaryContact;

  String name;

  @LocalDateConverter()
  LocalDate startDate;

  // if the customer status is pending suspension or
  // suspended then this field will hold the date the
  // user will be suspended.
  // The customer will be supsended at 3pm on the
  // given date.
  @LocalDateConverter()
  LocalDate suspensionDate;

  /// List of phone numbers this organisation holds
  /// and how those numbers are routed into the
  /// organisation.
  @ERConverterDIDForward()
  List<ER<DIDForward>> ownedPhoneNumbers = [];

  @ERConverterOficeHolidays()
  ER<OfficeHolidays> officeHolidays;

  @ERRegionConverter()
  ER<Region> region;

  @LocalDateConverter()
  LocalDate trialExpiryDate;

  Customer();

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  bool get isActive =>
      suspensionDate != null &&
      suspensionDate.isBeforeOrEqual(LocalDate.today());

  @override
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
