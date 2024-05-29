import 'dart:convert';

import '../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

class ActionGetById<E extends Entity<E>> extends Action<E> {
  ActionGetById(this.id, this.repository, RetryData retryData)
      : super(retryData);
  final int id;
  final Repository<E> repository;

  @override
  E decodeResponse(ActionResponse data) =>
      repository.fromJson(data.singleEntity!);

  @override
  String encodeRequest() {
    final map = <String, Object>{};
    map[Action.action] = 'getById';
    map[Action.mutatesKey] = causesMutation;
    map[Action.entityTypeKey] = repository.entity;
    map[Action.idKey] = id.toString();

    return json.encode(map);
  }

  @override
  List<Object> get props => [repository.entity, id];
  @override
  bool get causesMutation => false;
}
