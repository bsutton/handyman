import 'dart:convert';

import '../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/query.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

class ActionQuery<E extends Entity<E>> extends Action<List<E>> {
  ActionQuery(this.query, this.repository, RetryData retryData)
      : super(retryData);
  final Query query;
  final Repository<E> repository;

  @override
  List<E> decodeResponse(ActionResponse data) {
    final results = <E>[];

    for (final entity in data.entityList!) {
      results.add(repository.fromJson(entity as Map<String, Object>));
    }

    return results;
  }

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'selectFiltered';
    map[Action.mutatesKey] = causesMutation;
    map[Action.entityTypeKey] = repository.entity;
    map[Action.queryKey] = query.toJson();

    return json.encode(map);
  }

  @override
  bool get causesMutation => false;

  @override
  List<Object> get props => [repository.entity, query];
}
