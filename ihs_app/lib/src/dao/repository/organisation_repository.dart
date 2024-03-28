import '../entities/organisation.dart';
import 'repository.dart';

class OrganisationRepository extends Repository<Organisation> {
  OrganisationRepository() : super(const Duration(minutes: 5));

  @override
  Organisation fromJson(Map<String, dynamic> json) =>
      Organisation.fromJson(json);
}
