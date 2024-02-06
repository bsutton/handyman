import 'package:email_validator/email_validator.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../util/strings.dart';

class EmailAddress {
  EmailAddress(this.value) {
    value = value.trim();
    if (!isValid(value)) {
      throw ArgumentError('Invalid Email Address');
    }
  }
  String value;

  int compareTo(EmailAddress other) => value.compareTo(other.value);

  @override
  String toString() => value;

  bool isValidAddress() => EmailAddress.isValid(value);

  static bool isValid(String emailAddress) =>
      !Strings.isNullOrEmpty(emailAddress) &&
      EmailValidator.validate(emailAddress);
}

class EmailAddressConverter implements JsonConverter<EmailAddress, String> {
  const EmailAddressConverter();

  @override
  EmailAddress fromJson(String? json) =>
      json == null ? EmailAddress('') : EmailAddress(json);

  @override
  String toJson(EmailAddress email) => email.toString();
}
