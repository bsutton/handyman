import 'dart:convert';
import '../../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../../types/er.dart';
import '../repository.dart';
import 'action.dart';

class ActionUpdate<E extends Entity<E>> extends Action<ER<E>> {
  final E entity;
  final Repository<E> repository;
  ActionUpdate(this.entity, this.repository, RetryData retryData) : super(retryData);

  @override
  ER<E> decodeResponse(ActionResponse response) {
    return ER(repository.fromJson(response.singleEntity));
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'update';
    map[Action.MUTATES] = causesMutation;
    map[Action.ENTITY_TYPE] = repository.entity;
    map[Action.ENTITY] = entity.toJson();
    map[Action.ID] = entity.id;

    return json.encode(map);
  }

  @override
  List<Object> get props => [repository.entity, entity.guid];

  @override
  bool get causesMutation => true;
}
