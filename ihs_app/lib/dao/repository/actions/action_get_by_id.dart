import 'dart:convert';
import '../../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

class ActionGetById<E extends Entity<E>> extends Action<E> {
  final int id;
  final Repository<E> repository;
  ActionGetById(this.id, this.repository, RetryData retryData) : super(retryData);

  @override
  E decodeResponse(ActionResponse data) {
    return repository.fromJson(data.singleEntity);
  }

  @override
  String encodeRequest() {
    var map = <String, Object>{};
    map[Action.ACTION] = 'getById';
    map[Action.MUTATES] = causesMutation;
    map[Action.ENTITY_TYPE] = repository.entity;
    map[Action.ID] = id.toString();

    return json.encode(map);
  }

  @override
  List<Object> get props => [repository.entity, id];
  @override
  bool get causesMutation => false;
}
