import 'package:json_annotation/json_annotation.dart';

import '../types/email_address.dart';
import '../types/er.dart';
import '../types/phone_number.dart';
import 'address.dart';
import 'customer.dart';
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
      _$ContactFromJson(json);
  late String firstname;
  late String surname;

  @ERConverterAddress()
  late Address address;

  @ERConverterCustomer()
  late Customer customer;

  @ConverterEmailAddress()
  String? email;

  @ConverterPhoneNumber()
  PhoneNumber? mobile;

  String get name => '$firstname  surname';

  @override
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
