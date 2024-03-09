import '../../entities/entity_settings.dart';
import '../../entities/ivr.dart';
import 'repository.dart';

class IVRRepository extends Repository<IVR> implements EntitySettings<IVR> {
  IVRRepository() : super(Duration(minutes: 5));

  @override
  IVR fromJson(Map<String, dynamic> json) => IVR.fromJson(json);
}
