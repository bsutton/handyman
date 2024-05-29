import '../entities/check_list_item.dart';
import '../types/guid.dart';
import 'repository.dart';

class ChecklistItemRepository extends Repository<ChecklistItem> {
  ChecklistItemRepository() : super(const Duration(minutes: 5));

  @override
  ChecklistItem fromJson(Map<String, dynamic> json) =>
      ChecklistItem.fromJson(json);

  Future<List<ChecklistItem>> getByCustomerGUID(GUID customerGUID) =>
      getList('owner.guid', customerGUID.toString());
}
