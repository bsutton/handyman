import 'package:json_annotation/json_annotation.dart';

import '../../util/local_date.dart';
import '../types/er.dart';
import 'entity.dart';
import 'user.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer extends Entity<Customer> {
  Customer();

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  @ERConverterUser()
  late ER<User> primaryContact;

  late String name;

  @LocalDateConverter()
  late LocalDate createdDate;

  @override
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
