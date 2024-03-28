import 'dart:convert';

import '../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

class ActionDelete<E extends Entity<E>> extends Action<bool> {
  ActionDelete(this.entity, this.repository, RetryData retryData)
      : super(retryData);
  final E entity;
  final Repository<E> repository;

  @override
  bool decodeResponse(ActionResponse data) => data.wasSuccessful();

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'deleteById';
    map[Action.mutatesKey] = causesMutation;
    map[Action.entityTypeKey] = repository.entity;
    map[Action.idKey] = entity.id;

    return json.encode(map);
  }

  @override
  List<Object> get props => [repository.entity, entity.guid!];

  @override
  bool get causesMutation => true;
}
