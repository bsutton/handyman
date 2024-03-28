import '../entities/job.dart';
import '../types/guid.dart';
import 'repository.dart';

class JobRepository extends Repository<Job> {
  JobRepository() : super(const Duration(minutes: 5));

  @override
  Job fromJson(Map<String, dynamic> json) => Job.fromJson(json);

  Future<List<Job>> getByCustomer(GUID customerGuid) async =>
      getList('customer.guid', customerGuid.toString());
}
