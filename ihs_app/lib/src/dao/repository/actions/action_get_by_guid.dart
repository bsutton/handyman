import 'dart:convert';
import '../../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/guid.dart';
import '../repository.dart';
import 'action.dart';

class ActionGetByGuid<E extends Entity<E>> extends Action<E> {
  final GUID guid;
  final Repository<E> repository;
  ActionGetByGuid(this.guid, this.repository, RetryData retryData) : super(retryData);

  @override
  E decodeResponse(ActionResponse data) {
    return repository.fromJson(data.singleEntity);
  }

  @override
  String encodeRequest() {
    var map = <String, Object>{};
    map[Action.ACTION] = 'getByGuid';
    map[Action.MUTATES] = causesMutation;
    map[Action.ENTITY_TYPE] = repository.entity;
    map[Action.GUID] = guid.toString();

    return json.encode(map);
  }

  @override
  List<Object> get props => [repository.entity, guid];

  @override
  bool get causesMutation => false;
}
