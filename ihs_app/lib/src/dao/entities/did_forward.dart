import 'package:json_annotation/json_annotation.dart';
import '../types/er.dart';
import '../types/phone_number.dart';
import 'check_list_item_type.dart';
import 'customer.dart';
import 'did_allocation.dart';
import 'entity.dart';

part 'did_forward.g.dart';

/// Holds a PhoneNumber and and details
/// on how calls to the number are fowarded (routed)
/// into the organization
@JsonSerializable()
class DIDForward extends Entity<DIDForward> {
  @ERCustomerConverter()
  ER<Customer> owner;
  @PhoneNumberConverter()
  PhoneNumber did;

  @ERDIDAllocationConverter()
  ER<DIDAllocation> allocation;

  @ERCallForwardTargetConverter()
  ER<CallForwardTarget> callForwardTarget;

  DIDForward();

  factory DIDForward.fromJson(Map<String, dynamic> json) =>
      _$DIDForwardFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DIDForwardToJson(this);
}
