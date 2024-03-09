import '../../entities/call_forward_target.dart';
import '../../entities/dnd.dart';
import 'repository.dart';

class CallForwardTargetRepository extends Repository<CallForwardTarget> {
  CallForwardTargetRepository() : super(Duration(seconds: 5));

  Future<CallForwardTarget> getByDND(DND dnd) async {
    return getFirst('guid', dnd.callForwardTarget.guid.toString());
  }

  @override
  CallForwardTarget fromJson(Map<String, dynamic> json) {
    return CallForwardTarget.fromJson(json);
  }
}
