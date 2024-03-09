import 'package:json_annotation/json_annotation.dart';

import '../types/email_address.dart';
import '../types/phone_number.dart';
import 'entity.dart';

part 'contact.g.dart';

///
///Not certain this is required.
/// At the moment it is used by the Conference
/// entity and nothing else.
///
@JsonSerializable()
class Contact extends Entity<Contact> {
  Contact();

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$CallerDetailsFromJson(json);
  String firstname;
  String surname;

  @ERConverterOficeHolidays()
  Address address;
  String company;
  @EmailAddressConverter()
  String email;

  @PhoneNumberConverter()
  PhoneNumber mobile;

  String get name => '$firstname  surname';

  @override
  Map<String, dynamic> toJson() => _$CallerDetailsToJson(this);
}
