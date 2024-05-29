import '../entities/customer.dart';
import '../transaction/query.dart';
import 'repository.dart';

class CustomerRepository extends Repository<Customer> {
  CustomerRepository() : super(const Duration(minutes: 5));

  Future<Customer?> get owner async {
    // we can only ever see the owning customer in the
    // returned set so the first one that comes back must
    // be the owner.
    final query = Query(entity, limit: 1);

    return select(query).then((result) {
      if (result.isNotEmpty) {
        return result[0];
      }
      return null;
    });
  }

  @override
  String get entity => 'Customer';

  @override
  Customer fromJson(Map<String, dynamic> json) => Customer.fromJson(json);
}
