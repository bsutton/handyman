import 'package:recase/recase.dart';

///
/// Provides a collection of methods that help when working with
/// enums.
///
mixin EnumHelper {
  ///
  static T getByIndex<T>(List<T> values, int index) =>
      values.elementAt(index - 1);

  ///
  static int getIndexOf<T>(List<T> values, T value) => values.indexOf(value);

  ///
  /// Returns the Enum name without the enum class.
  /// e.g. DayName.Wednesday becomes Wednesday.
  /// By default we recase the value to Title Case.
  /// You can pass an alternate method to control the format.
  ///
  static String getName<T>(T enumValue,
      {String Function(String value) recase = reCase}) {
    final name = enumValue.toString();
    final period = name.indexOf('.');

    return recase(name.substring(period + 1));
  }

  ///
  static String reCase(String value) => ReCase(value).titleCase;

  ///
  static T getEnum<T>(String enumName, List<T> values) {
    final cleanedName = reCase(enumName);
    for (var i = 0; i < values.length; i++) {
      if (cleanedName == getName(values[i])) {
        return values[i];
      }
    }
    throw Exception("$cleanedName doesn't exist in the list of enums $values");
  }
}
