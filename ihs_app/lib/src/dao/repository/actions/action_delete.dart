import 'dart:convert';
import '../../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

class ActionDelete<E extends Entity<E>> extends Action<bool> {
  final E entity;
  final Repository<E> repository;
  ActionDelete(this.entity, this.repository, RetryData retryData) : super(retryData);

  @override
  bool decodeResponse(ActionResponse data) {
    return data.wasSuccessful();
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map[Action.ACTION] = 'deleteById';
    map[Action.MUTATES] = causesMutation;
    map[Action.ENTITY_TYPE] = repository.entity;
    map[Action.ID] = entity.id;

    return json.encode(map);
  }

  @override
  List<Object> get props => [repository.entity, entity.guid];

  @override
  bool get causesMutation => true;
}
