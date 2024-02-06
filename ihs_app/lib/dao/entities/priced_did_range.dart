import 'package:json_annotation/json_annotation.dart';
import 'package:money2/money2.dart';
import '../../util/money_converter.dart';
import '../types/er.dart';
import 'customer.dart';
import 'did_pool.dart';
import 'did_range.dart';
import 'region.dart';

part 'priced_did_range.g.dart';

enum ValuationType { PREMIUM, NON_PREMIUM }

@JsonSerializable()
class PricedDIDRange {
  ValuationType valuationType;

  @ERCustomerConverter()
  ER<Customer> owner;

  @ERDIDPoolConverter()
  ER<DIDPool> pool;

  @ERRegionConverter()
  ER<Region> region;

  // @ERPoolConverter()
  // ER<DIDPool> pool;

  DIDRange didRange;

  // The price we are selling the DID range for.
  // This is the charge price per month.
  @MoneyConverter()
  Money chargePrice;

  PricedDIDRange(
      this.region, this.didRange, this.chargePrice, this.valuationType);

  String get formattedRange => didRange.format;

  factory PricedDIDRange.fromJson(Map<String, dynamic> json) =>
      _$PricedDIDRangeFromJson(json);

  Map<String, dynamic> toJson() => _$PricedDIDRangeToJson(this);
}
