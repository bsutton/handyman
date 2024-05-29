import 'package:json_annotation/json_annotation.dart';
import 'package:money2/money2.dart';

class MoneyConverter implements JsonConverter<Money, String> {
  const MoneyConverter();

  @override
  Money fromJson(String? json) {
    if (json == null) {
      return Money.fromIntWithCurrency(0, CommonCurrencies().aud);
    } else {
      json = json.substring(4);
      return Money.parse(json, isoCode: 'AUD', pattern: '#.##');
    }
  }

  @override
  String toJson(Money money) => money.format('CCC#.##');
}
