import '../../entities/did_forward.dart';
import '../types/guid.dart';
import 'repository.dart';

class DIDForwardRepository extends Repository<DIDForward> {
  DIDForwardRepository() : super(Duration(minutes: 5));

  @override
  DIDForward fromJson(Map<String, dynamic> json) {
    return DIDForward.fromJson(json);
  }

  Future<List<DIDForward>> getByCustomerGUID(GUID customerGUID) {
    return getList('owner.guid', customerGUID.toString());
  }
}
