import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';

import '../../../util/strings.dart';

@immutable
class PhoneNumber {
  PhoneNumber(String phone) : phone = normalisePhone(phone);
  final String phone;

  static String normalisePhone(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(' ', '');

    // strip + prefix
    if (phoneNumber.startsWith('+')) {
      phoneNumber = phoneNumber.substring(1, phoneNumber.length);
    }

    // add missing 0
    if (phoneNumber.length == 9 && phoneNumber[0] != '0') {
      phoneNumber = '0$phoneNumber';
    }

    // // Add 61 prefix
    // if (phoneNumber.length == 10 && phoneNumber.startsWith("0")) {
    //   phoneNumber = "61" + phoneNumber.substring(1, phoneNumber.length);
    // }

    return phoneNumber;
  }

  int compareTo(PhoneNumber rhs) => phone.compareTo(rhs.phone);

  bool contains(String filter) {
    filter = filter.replaceAll(' ', '');

    return phone.contains(filter);
  }

  bool isValid({bool allowEmpty = false}) {
    final result = PhoneNumber.validate(phone, allowEmpty: allowEmpty);

    return result.isValid();
  }

  /// Use this method to pass to a FormTextField validator.
  static String? formFieldValidate(String phoneNumber,
      {required String fieldName, bool allowEmpty = true}) {
    final results = PhoneNumber.validate(phoneNumber,
        allowEmpty: allowEmpty, fieldName: fieldName);

    if (results == const ValidationResult.ok()) {
      return null;
    }

    return results.message;
  }

  static ValidationResult validate(String phoneNumber,
      {String fieldName = '', bool allowEmpty = true}) {
    final regex = RegExp(r'^\d+$');

    final isEmpty = Strings.isNullOrEmpty(phoneNumber);

    if (allowEmpty && isEmpty) {
      return const ValidationResult.ok();
    }

    if (!allowEmpty && isEmpty) {
      return ValidationResult.error(
          '${fieldName ?? 'Phone numbers'} may not be empty.');
    }

    if (!isEmpty) {
      phoneNumber = phoneNumber.replaceAll(' ', '');
      // strip leading +
      phoneNumber = phoneNumber.replaceFirst('+', '');
      // strip country prefix
      if (phoneNumber.startsWith('61')) {
        phoneNumber = '0${phoneNumber.substring(2)}';
      }

      if (!regex.hasMatch(phoneNumber)) {
        return ValidationResult.error(
            '${fieldName ?? 'Phone numbers'} may ONLY contain digits.');
      }

      if (phoneNumber.length != 10) {
        return ValidationResult.error(
            '${fieldName ?? 'Phone numbers'} MUST be 10 digits long.');
      }
    }
    return const ValidationResult.ok();
  }

  bool endsWith(String suffix) => phone.endsWith(suffix);

  int length() => phone.length;

  bool equals(PhoneNumber rhs) => toNational() == rhs.toNational();

  bool operator >(PhoneNumber rhs) {
    final self = BigInt.parse(phone);
    final other = BigInt.parse(rhs.phone);

    return self - other > BigInt.zero;
  }

  ///
  /// We consider the DID to be adjacent to the current PhoneNumber if it is one less or one greater that our phone
  /// number.
  ///
  /// @param rhs
  /// @return
  ///
  bool isAdjacentTo(PhoneNumber rhs) =>
      add(1).equals(rhs) || subtract(1).equals(rhs);

  ///
  /// @param nextNumber
  /// @return true if nextNumber is the next number (numerically) after this number
  ///
  bool isSequential(PhoneNumber nextNumber) => add(1).equals(nextNumber);

  String getLeadingZeros() {
    var leadingZeros = '';

    for (var i = 0; i < phone.length; i++) {
      final digit = phone[i];
      if (digit == '0') {
        leadingZeros += '0';
      } else {
        break;
      }
    }

    return leadingZeros;
  }

  @override
  bool operator ==(covariant PhoneNumber rhs) => phone == rhs.phone;

  @override
  int get hashCode => phone.hashCode;

  bool operator >=(PhoneNumber rhs) => equals(rhs) || this > rhs;

  bool operator <(PhoneNumber rhs) => !(this >= rhs);

  bool isLessThanOrEqual(PhoneNumber rhs) => this < rhs || this == rhs;

  bool equal(PhoneNumber rhs) => phone == rhs.phone;

/////
  /// Adds 'operand' to the existing phone number by treating the phone number as a big int and returns the next phone
  /// number numerically. e.g. 0383208100.add(1) becomes 03 8320 8101
  ///
  /// @param operand
  /// @return
  ///
  PhoneNumber add(int operand) {
    final leadingZeros = getLeadingZeros();

    final bdPhone = BigInt.parse(phone);
    final result = bdPhone + BigInt.from(operand);

    return PhoneNumber(leadingZeros + result.toString());
  }

  PhoneNumber subtract(int operand) {
    final leadingZeros = getLeadingZeros();

    final bdPhone = BigInt.parse(phone);
    final result = bdPhone - BigInt.from(operand);

    return PhoneNumber(leadingZeros + result.toString());
  }

  @override
  String toString() => toNational();

  ///
  /// outputs a nicely formatted version of the number e.g. XX XXXX XXXX
  ///
  static String prettyPrint(String phoneNumber) {
    String result;

    if (phoneNumber.isEmpty) {
      result = '';
    } else if (phoneNumber.length == 6 && phoneNumber.startsWith('13')) {
      result =
          '${phoneNumber.substring(0, 2)} ${phoneNumber.substring(2, 4)} ${phoneNumber.substring(4)}';
    } else if (phoneNumber.length == 8) {
      // local number
      result = '${phoneNumber.substring(0, 4)} ${phoneNumber.substring(4, 8)}';
    } else if (phoneNumber.length == 10 &&
        (isMobile(phoneNumber) || phoneNumber.startsWith('1300'))) {
      result =
          '${phoneNumber.substring(0, 4)} ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}';
    } else if (phoneNumber.length == 10) {
      if (isMobile(phoneNumber)) {
        result = '${phoneNumber.substring(0, 4)} ${phoneNumber.substring(4, 7)}'
            ' '
            '${phoneNumber.substring(7)}';
      } else {
        result = '${phoneNumber.substring(0, 2)}'
            ' '
            '${phoneNumber.substring(2, 6)}'
            ' '
            '${phoneNumber.substring(6)}';
      }
    } else if (phoneNumber.length == 11) {
      result = '${phoneNumber.substring(0, 3)}'
          ' '
          '${phoneNumber.substring(3, 7)}'
          ' '
          '${phoneNumber.substring(7)}';
    } else {
      result = phoneNumber;
    }

    return result;
  }

  bool isMobileNo() => PhoneNumber.isMobile(phone);

  static bool isMobile(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(' ', '');
    return (phoneNumber.startsWith('04') && phoneNumber.length == 10) ||
        (phoneNumber.startsWith('614') && phoneNumber.length == 11);
  }

  bool isEmpty() => phone.isEmpty;

  String toCompactString() => phone;

  bool isAustralianNo() {
    var itIs = false;

    final len = phone.length;

    if (phone.startsWith('61') && len == 11) {
      if (phone.startsWith('612') ||
          phone.startsWith('613') ||
          phone.startsWith('614') ||
          phone.startsWith('615') ||
          phone.startsWith('616') ||
          phone.startsWith('617') ||
          phone.startsWith('618') ||
          phone.startsWith('619')) {
        itIs = true;
      }
    }

    if (phone.startsWith('13') && (len == 6 || len == 10)) {
      itIs = true;
    }

    if (phone.startsWith('18') && len == 10) {
      itIs = true;
    }

    return itIs;
  }

  ///
  /// @return formated for national dialing with australia e.g. 03 xxxx xxxx
  ///
  String toNational() {
    var national = phone;

    if (phone.startsWith('61')) national = '0${phone.substring(2)}';

    return prettyPrint(national);
  }

  String getLocalNumber() => Strings.right(phone, 8);

  String getAreaCode() => '61${Strings.right(Strings.left(phone, 3), 1)}';

  String getCountryCode() => Strings.left(phone, 2);

  String toE164() {
    if (phone.startsWith('61')) {
      return '+$phone';
    }
    if (phone.startsWith('0')) {
      return '+61${phone.substring(1)}';
    }
    return '+61$phone';
  }
}

class PhoneNumberConverter implements JsonConverter<PhoneNumber, String> {
  const PhoneNumberConverter();
  @override
  PhoneNumber fromJson(String json) => PhoneNumber(json);

  @override
  String toJson(PhoneNumber phoneNumber) =>
      phoneNumber == null ? '' : phoneNumber.toCompactString();
}

@immutable
class ValidationResult {
  const ValidationResult.error(this.message) : valid = false;

  const ValidationResult.ok()
      : message = 'OK',
        valid = true;
  final bool valid;
  final String message;

  bool isValid() => valid;

  @override
  bool operator ==(covariant ValidationResult other) =>
      message == other.message && valid == other.valid;

  @override
  int get hashCode => hash2(message, valid);
}
