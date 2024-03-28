import '../entities/check_list_item_type.dart';
import 'repository.dart';

class ChecklistItemTypeRepository extends Repository<ChecklistItemType> {
  ChecklistItemTypeRepository() : super(const Duration(minutes: 5));

  @override
  ChecklistItemType fromJson(Map<String, dynamic> json) =>
      ChecklistItemType.fromJson(json);
}
