import 'package:json_annotation/json_annotation.dart';
import 'package:money2/money2.dart';
import '../../util/money_converter.dart';
import '../types/er.dart';
import 'address.dart';
import 'did_range.dart';
import 'entity.dart';

part 'did_pool.g.dart';

enum PoolStatus {
  ACTIVE,
  PENDING_DELETE,
  DELETED,
}

enum AustralianState {
  VIC,
  NSW,
  QLD,
  TAS,
  NT,
  ACT,
  WA,
  SA,
  International,
  Mobile
}

@JsonSerializable()
class DIDPool extends Entity<DIDPool> {
  // @ERProviderConverter()
  // Provider provider;

  AustralianState australianState;

  @ERCountryConverter()
  ER<Country> country;

  DIDRange didRange;

  // The amount we will charge a customer for a single premium no. from this range
  // The class DIDPoolDao contains logic to select premium and non-premium nos.
  @MoneyConverter()
  Money premium1Charge;

  // The amount we will charge a customer for a single non-premium no. from this range
  @MoneyConverter()
  Money nonPremium1Charge;

  // The amount we will charge a customer for a 100 range of premium no. from this range
  // The class DIDPoolDao contains logic to select premium and non-premium nos.
  @MoneyConverter()
  Money premium100Charge;

  // The amount we will charge a customer for a 100 range of non-premium no. from this range
  @MoneyConverter()
  Money nonPremium100Charge;

  PoolStatus poolStatus;

  // requried by json
  DIDPool();

  factory DIDPool.fromJson(Map<String, dynamic> json) =>
      _$DIDPoolFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DIDPoolToJson(this);
}
