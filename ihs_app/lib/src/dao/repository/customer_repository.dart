import '../../entities/customer.dart';
import '../../entities/did_forward.dart';
import '../../entities/office_holidays.dart';
import '../transaction/query.dart';
import '../types/er.dart';
import 'repository.dart';

class CustomerRepository extends Repository<Customer> {
  CustomerRepository() : super(Duration(minutes: 5));

  Future<Customer> get owner async {
    // we can only ever see the owning customer in the
    // returned set so the first one that comes back must
    // be the owner.
    var query = Query(entity, limit: 1);

    return select(query).then((result) {
      if (result.isNotEmpty) {
        return result[0];
      }
      return null;
    });
  }

  Future<ER<OfficeHolidays>> get officeHolidays async {
    var owner = await this.owner;

    return owner.officeHolidays;
  }

  Future<List<DIDForward>> get ownedPhoneNumbers async {
    var owner = await this.owner;
    return (owner.ownedPhoneNumbers == null ? null : ER.decantList(owner.ownedPhoneNumbers));
  }

  @override
  String get entity => 'Customer';

  @override
  Customer fromJson(Map<String, dynamic> json) {
    return Customer.fromJson(json);
  }
}
