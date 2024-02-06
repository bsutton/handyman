import 'dart:math';

class Strings {
  /// Returns the [length] characters starting
  /// from the end of of the string.
  static String right(String value, int length) {
    var len = value.length;
    var right = min(len, length);
    var start = len - right;
    var end = len;
    return value.substring(start, end);
  }

  /// Returns the [length] characters starting
  /// from the begining part of the string.
  static String left(String value, int length) {
    var len = value.length;
    var left = min(len, length);
    var start = 0;
    var end = left;
    return value.substring(start, end);
  }

  static bool isNullOrEmpty(String value) {
    return value == null || value.isEmpty;
  }

  static bool isNotEmpty(String value) {
    return value != null && value.isNotEmpty;
  }

  static const digits = '0123456789';

  ///
  ///Checks that the string only contains digits.
  static bool isDigitsOnly(String value) {
    var valid = true;

    for (var i = 0; i < value.length; i++) {
      var char = value[i];
      if (!digits.contains(char)) {
        valid = false;
        break;
      }
    }
    return valid;
  }

  /// Returns the string bounded by the left and right delimiters.
  /// Throws an exception if either of the delimiters are missing.
  /// If there are nested delimiters we return the outer most
  /// delimiters. If there are sets of delimiters you are on your own.
  static String within(String string, String left, String right) {
    var leftIndex = string.indexOf(left);
    var rightIndex = string.lastIndexOf(right);

    if (leftIndex == -1) {
      throw ArgumentError('The left bounding character was missing');
    }

    if (rightIndex == -1) {
      throw ArgumentError('The right bounding character was missing');
    }

    var within = string.substring(leftIndex + 1, rightIndex);
    return within;
  }

  ///
  /// Returns the left most part of a string upto,
  /// but not including, the delimiter
  ///
  static String upTo(String string, String delimiter) {
    var index = string.indexOf(delimiter);
    if (index == -1) {
      index = string.length;
    }
    return string.substring(0, index);
  }
}
