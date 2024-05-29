import '../entities/role.dart';
import 'repository.dart';

class RoleRepository extends Repository<Role> {
  RoleRepository() : super(const Duration(minutes: 5));

  @override
  Role fromJson(Map<String, dynamic> json) => Role.fromJson(json);
}
