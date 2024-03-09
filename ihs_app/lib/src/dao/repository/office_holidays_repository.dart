import '../../entities/office_holidays.dart';
import '../types/guid.dart';
import 'repository.dart';

class OfficeHolidaysRepository extends Repository<OfficeHolidays> {
  OfficeHolidaysRepository() : super(Duration(minutes: 5));

  @override
  OfficeHolidays fromJson(Map<String, dynamic> json) {
    return OfficeHolidays.fromJson(json);
  }

  Future<OfficeHolidays> getByUser(GUID userGuid) async {
    return getFirst('owner.guid', userGuid.toString());
  }
}
