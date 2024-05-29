import 'dart:convert';

import '../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/query.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

class ActionCount<E extends Entity<E>> extends Action<int> {
  ActionCount(this.query, this.repository, RetryData retryData)
      : super(retryData);
  final Query query;
  final Repository<E> repository;

  @override
  int decodeResponse(ActionResponse data) => data.data!['count'] as int;

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map['Action'] = 'countFiltered';
    map[Action.mutatesKey] = causesMutation;
    map['EntityType'] = repository.entity;
    map['Query'] = query.toJson();

    return json.encode(map);
  }

  @override
  bool get causesMutation => false;

  @override
  List<Object> get props => [repository.entity, query];
}
