import 'dart:convert';
import '../../../entities/tutorial.dart';
import '../../transaction/transaction.dart';
import '../tutorial_repository.dart';
import 'action.dart';

class ActionGetNewTutorials extends CustomAction<List<Tutorial>> {
  final TutorialRepository repository = TutorialRepository();

  @override
  List<Tutorial> decodeResponse(ActionResponse data) {
    var results = <Tutorial>[];

    for (var entity in data.entityList) {
      results.add(repository.fromJson(entity as Map<String, Object>));
    }

    return results;
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'getNewTutorials';
    map[Action.MUTATES] = causesMutation;

    return json.encode(map);
  }

  @override
  bool get causesMutation => false;

  @override
  List<Object> get props => [];

  @override
  Future<List<Tutorial>> run() async {
    return await repository.getNewTutorials();
  }
}
