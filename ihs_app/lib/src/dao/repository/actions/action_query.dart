import 'dart:convert';
import '../../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/query.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

class ActionQuery<E extends Entity<E>> extends Action<List<E>> {
  final Query query;
  final Repository<E> repository;
  ActionQuery(this.query, this.repository, RetryData retryData) : super(retryData);

  @override
  List<E> decodeResponse(ActionResponse data) {
    var results = <E>[];

    for (var entity in data.entityList) {
      results.add(repository.fromJson(entity as Map<String, Object>));
    }

    return results;
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'selectFiltered';
    map[Action.MUTATES] = causesMutation;
    map[Action.ENTITY_TYPE] = repository.entity;
    map[Action.QUERY] = query.toJson();

    return json.encode(map);
  }

  @override
  bool get causesMutation => false;

  @override
  List<Object> get props => [repository.entity, query];
}
