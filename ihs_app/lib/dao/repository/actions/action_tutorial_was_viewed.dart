import 'dart:convert';
import '../../../bus/bus.dart';
import '../../../entities/tutorial.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import 'action.dart';

class TutorialWasViewedAction extends Action<void> {
  final Tutorial tutorial;

  TutorialWasViewedAction(this.tutorial) : super(RetryData.defaultRetry);

  @override
  bool get causesMutation => true;

  @override
  void decodeResponse(ActionResponse data) {
    // void response so just tell everyone what we have done.
    Bus().add<TutorialWasViewedAction>(BusAction.update, instance: this);
  }

  @override
  String encodeRequest() {
    Map<String, Object> map = <String, dynamic>{};
    map[Action.ACTION] = 'tutorial_was_viewed';
    map[Action.MUTATES] = causesMutation;
    map['tutorial_id'] = tutorial.id;

    return json.encode(map);
  }

  @override
  List<Object> get props => [tutorial];
}
