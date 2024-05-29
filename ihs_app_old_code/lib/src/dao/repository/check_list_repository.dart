import '../entities/check_list.dart';
import '../types/guid.dart';
import 'repository.dart';

class ChecklistRepository extends Repository<Checklist> {
  ChecklistRepository() : super(const Duration(minutes: 5));

  Future<List<Checklist>> getByChecklist(GUID checklistGuid) async =>
      getList('checklist.guid', checklistGuid.toString());

  @override
  Checklist fromJson(Map<String, dynamic> json) => Checklist.fromJson(json);
}
