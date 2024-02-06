import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';
import '../types/area_code.dart';
import '../types/er.dart';
import '../types/timezone.dart';
import 'address.dart';
import 'entity.dart';

///
/// A geographical region representing an singular AreaCode/Timezone combination.
///

part 'region.g.dart';

/// A region describes a geographical location
/// an associated [timezone] and [areaCode].
@JsonSerializable()
class Region extends Entity<Region> {
  @ERCountryConverter()
  ER<Country> country;

  String state;

  String city;

  /// The timezone used for this location.
  @TimezoneConverter()
  Timezone timezone;

  @AreaCodeConverter()
  AreaCode areaCode;

  Region(this.country, this.state, this.city, this.timezone, this.areaCode);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(covariant Region other) {
    var equal = false;

    if (timezone.name == other.timezone.name &&
        state == other.state &&
        city == other.city) {
      equal = true;
    }

    return equal;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => hash3(timezone.name, state, city);

  Region.clone(Region region)
      : this(region.country, region.state, region.city, region.timezone,
            region.areaCode);

  @override
  Future<bool> search(String filter) async {
    await country.resolve;
    return country.entity.name.contains(filter) || city.contains(filter);
  }

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RegionToJson(this);
}
