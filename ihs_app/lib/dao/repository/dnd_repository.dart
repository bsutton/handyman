import '../../entities/dnd.dart';
import '../types/guid.dart';
import 'repository.dart';

class DNDRepository extends Repository<DND> {
  DNDRepository() : super(Duration(minutes: 5));

  Future<DND> getByUser(GUID userGUID) async {
    return getFirst('owner.guid', userGUID.toString());
  }

  @override
  DND fromJson(Map<String, dynamic> json) {
    return DND.fromJson(json);
  }
}
