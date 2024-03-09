import 'package:json_annotation/json_annotation.dart';
import '../enums/limit_type.dart';
import '../types/er.dart';
import 'entity.dart';
import 'limit_options.dart';
import 'user.dart';

part 'limit.g.dart';

@JsonSerializable()
class Limit extends Entity<Limit> {
  @ERUserConverter()
  ER<User> user;

  LimitType type;

  String description;

  @ERLimitOptionConverter()
  List<ER<LimitOption>> options;

  @ERLimitOptionConverter()
  ER<LimitOption> currentOption;

  Limit();

  String getDescription() {
    return description;
  }

  List<ER<LimitOption>> getOptions() {
    return options;
  }

  ER<LimitOption> getCurrentOption() {
    return currentOption;
  }

  factory Limit.fromJson(Map<String, dynamic> json) => _$LimitFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LimitToJson(this);
}
