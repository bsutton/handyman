import 'dart:convert';
import '../../../entities/entity.dart';
import '../../transaction/api/retry/retry_data.dart';
import '../../transaction/query.dart';
import '../../transaction/transaction.dart';
import '../repository.dart';
import 'action.dart';

class ActionCount<E extends Entity<E>> extends Action<int> {
  final Query query;
  final Repository<E> repository;
  ActionCount(this.query, this.repository, RetryData retryData) : super(retryData);

  @override
  int decodeResponse(ActionResponse resonse) {
    return resonse.data['count'] as int;
  }

  @override
  String encodeRequest() {
    var map = <String, dynamic>{};
    map['Action'] = 'countFiltered';
    map[Action.MUTATES] = causesMutation;
    map['EntityType'] = repository.entity;
    map['Query'] = query.toJson();

    return json.encode(map);
  }

  @override
  bool get causesMutation => false;

  @override
  List<Object> get props => [repository.entity, query];
}
