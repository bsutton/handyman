import '../entities/checklist_template.dart';
import '../types/guid.dart';
import 'repository.dart';

class ChecklistTemplateRepository extends Repository<ChecklistTemplate> {
  ChecklistTemplateRepository() : super(const Duration(minutes: 5));

  Future<List<ChecklistTemplate>> getByOrganisation(
          GUID organisationGuid) async =>
      getList('owner.guid', organisationGuid.toString());

  @override
  ChecklistTemplate fromJson(Map<String, dynamic> json) =>
      ChecklistTemplate.fromJson(json);
}
