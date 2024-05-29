import 'dart:convert';

import '../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/er.dart';
import '../repository.dart';
import 'action.dart';

class ActionInsert<E extends Entity<E>> extends Action<ER<E>> {
  ActionInsert(this.entity, this.repository, RetryData retryData)
      : super(retryData);
  final E entity;
  final Repository<E> repository;

  @override
  ER<E> decodeResponse(ActionResponse data) =>
      ER(repository.fromJson(data.singleEntity!));

  @override
  String encodeRequest() {
    final map = <String, dynamic>{};
    map[Action.action] = 'insert';
    map[Action.mutatesKey] = causesMutation;
    map[Action.entityTypeKey] = repository.entity;
    map[Action.entityKey] = entity.toJson();

    return json.encode(map);
  }

  @override
  List<Object> get props => [repository.entity, entity.guid!];

  @override
  bool get causesMutation => true;
}
