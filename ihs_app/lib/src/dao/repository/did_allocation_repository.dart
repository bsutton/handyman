import '../../entities/did_allocation.dart';
import 'repository.dart';

class DIDAllocationRepository extends Repository<DIDAllocation> {
  DIDAllocationRepository() : super(Duration(minutes: 5));

  @override
  DIDAllocation fromJson(Map<String, dynamic> json) {
    return DIDAllocation.fromJson(json);
  }
}
