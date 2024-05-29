import '../entities/contact_role.dart';
import 'repository.dart';

class ContactRoleRepository extends Repository<ContactRole> {
  ContactRoleRepository() : super(const Duration(minutes: 5));

  @override
  ContactRole fromJson(Map<String, dynamic> json) => ContactRole.fromJson(json);
}
