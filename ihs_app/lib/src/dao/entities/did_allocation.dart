import 'dart:async';
import 'package:json_annotation/json_annotation.dart';
import 'package:money2/money2.dart';
import '../../util/money_converter.dart';
import '../repository/repos.dart';
import '../types/er.dart';
import '../types/phone_number.dart';
import 'check_list_item_type.dart';
import 'customer.dart';
import 'did_pool.dart';
import 'did_range.dart';
import 'entity.dart';
import 'priced_did_range.dart';
import 'region.dart';

part 'did_allocation.g.dart';

@JsonSerializable()
class DIDAllocation extends Entity<DIDAllocation> {
  // The customer this allocation has been assigned to.
  @ERCustomerConverter()
  ER<Customer> owner;

  @ERRegionConverter()
  ER<Region> region;

  @ERDIDPoolConverter()
  ER<DIDPool> pool;

  // The actual DID range allocated.
  DIDRange didRange;

  // If true then we do not charge the customer for this DID Range
  bool nonChargable = false;

  // The amount we charge the customer for this DID Range.
  @MoneyConverter()
  Money chargePrice;

  @ERCallForwardTargetConverter()
  ER<CallForwardTarget> callForwardTarget;

  DIDAllocation();

  DIDAllocation.forInsert() : super.forInsert();

  // ctor to create allocations.
  static Future<DIDAllocation> load(
      Customer owner,
      PricedDIDRange pricedDIDRange,
      CallForwardTarget callForwardTarget) async {
    var instance = DIDAllocation();

    instance.callForwardTarget = ER(callForwardTarget);

    instance.didRange = pricedDIDRange.didRange;
    instance.chargePrice = pricedDIDRange.chargePrice;
    await instance.callForwardTarget.resolve.then((callForward) {
      callForward.forwardCallsTo = callForwardTarget.forwardCallsTo;
      callForward.colleague = callForwardTarget.colleague;
      callForward.externalNo = callForwardTarget.externalNo;
      callForward.ivr = callForwardTarget.ivr;
      callForward.recording = callForwardTarget.recording;
      callForward.messageMethod = callForwardTarget.messageMethod;
    });

    return instance;
  }

  PhoneNumber get startDID {
    return didRange.startOfDIDRange;
  }

  // Future<Future<Region>> get region {
  //   return pool.call((p) => p.re)
  // }

  factory DIDAllocation.fromJson(Map<String, dynamic> json) =>
      _$DIDAllocationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DIDAllocationToJson(this);

  static void assign(
      Customer customer, PricedDIDRange pricedDid, CallForwardTarget target) {
    target.owner = ER.fromGUID(customer.guid);
    Repos().callForwardTarget.insert(target);

    var allocation = DIDAllocation.forInsert();
    allocation.owner = ER(customer);
    allocation.region = pricedDid.region;
    allocation.pool = pricedDid.pool;
    allocation.callForwardTarget = ER(target);
    allocation.didRange = pricedDid.didRange;
    allocation.chargePrice = pricedDid.chargePrice;

    Repos().didAllocation.insert(allocation);
  }
}
