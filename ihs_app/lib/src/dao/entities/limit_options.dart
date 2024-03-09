import 'package:json_annotation/json_annotation.dart';
import 'package:money2/money2.dart';
import '../../util/money_converter.dart';
import 'entity.dart';

part 'limit_options.g.dart';

@JsonSerializable()
class LimitOption extends Entity<LimitOption> {
  String description;

  @MoneyConverter()
  Money cost;

  int quantity;

  LimitOption(this.description, this.cost, this.quantity);

  String getDescription() {
    return description;
  }

  factory LimitOption.fromJson(Map<String, dynamic> json) =>
      _$LimitOptionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LimitOptionToJson(this);
}
