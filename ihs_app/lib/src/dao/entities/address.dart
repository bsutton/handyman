import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';

import 'entity.dart';

part 'Address.g.dart';

@JsonSerializable()
class Address extends Entity<Address> {
  // required by Json
  Address();

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  String? street;
  String? suburb;
  String? postcode;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(covariant Address other) {
    const equals = false;

    if (other.runtimeType == runtimeType) {
      return street == other.street &&
          suburb == other.suburb &&
          postcode == other.postcode;
    }
    return equals;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => hash3(street, suburb, postcode);

  @override
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
