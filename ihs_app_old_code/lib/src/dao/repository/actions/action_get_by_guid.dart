import 'dart:convert';

import '../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

class ActionGetByGuid<E extends Entity<E>> extends Action<E> {
  ActionGetByGuid(this.guid, this.repository, RetryData retryData)
      : super(retryData);
  final GUID guid;
  final Repository<E> repository;

  @override
  E decodeResponse(ActionResponse data) =>
      repository.fromJson(data.singleEntity!);

  @override
  String encodeRequest() {
    final map = <String, Object>{};
    map[Action.action] = 'getByGuid';
    map[Action.mutatesKey] = causesMutation;
    map[Action.entityTypeKey] = repository.entity;
    map[Action.guidKey] = guid.toString();

    return json.encode(map);
  }

  @override
  List<Object> get props => [repository.entity, guid];

  @override
  bool get causesMutation => false;
}
