import 'package:money2/money2.dart';

extension MoneyEx on Money {
  static Money get zero => Money.fromInt(0, isoCode: 'AUD');

  static Money tryParse(String? amount) =>
      Money.tryParse(amount ?? '0', isoCode: 'AUD') ?? zero;
}
