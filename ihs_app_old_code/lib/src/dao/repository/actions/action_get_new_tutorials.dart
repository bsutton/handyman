import 'dart:convert';

import '../../entities/tutorial.dart';
import '../../transaction/transaction.dart';
import '../tutorial_repository.dart';
import 'action.dart';

class ActionGetNewTutorials extends CustomAction<List<Tutorial>> {
  final TutorialRepository repository = TutorialRepository();

  @override
  List<Tutorial> decodeResponse(ActionResponse data) {
    final results = <Tutorial>[];

    for (final entity in data.entityList!) {
      results.add(repository.fromJson(entity as Map<String, Object>));
    }

    return results;
  }

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'getNewTutorials';
    map[Action.mutatesKey] = causesMutation;

    return json.encode(map);
  }

  @override
  bool get causesMutation => false;

  @override
  List<Object> get props => [];

  @override
  Future<List<Tutorial>> run() async => repository.getNewTutorials();
}
